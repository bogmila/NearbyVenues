//
//  HttpServiceSpec.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import Nimble
import Quick

@testable import NearbyVenues

class HttpServiceSpec: QuickSpec {
    override func spec() {
        describe("Http Service") {
            var sut: HttpService!
            var urlSessionStub: URLSessionStub!

            beforeEach {
                urlSessionStub = URLSessionStub()
                sut = HttpService(session: urlSessionStub)
            }

            context("request") {
                it("should call data task") {
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { _ in })

                    expect(urlSessionStub.dataTaskCalled).to(beTrue())
                }

                it("should create request with correct server url") {
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { _ in })

                    let url = urlSessionStub.request?.url
                    expect(url?.scheme).to(equal("https"))
                    expect(url?.host).to(equal("api.foursquare.com"))
                    expect(url?.path).to(equal("/v2/venues/search"))
                    expect(url?.query).to(contain("client_id="))
                    expect(url?.query).to(contain("client_secret="))
                    expect(url?.query).to(contain("v="))
                }

                it("should create request with parameters") {
                    sut.request(type: DummyResponse.self, parameters: ["param1": "value1"], completion: { _ in })

                    let url = urlSessionStub.request?.url
                    expect(url?.query).to(contain("param1=value1"))
                    expect(url?.query).to(contain("client_id="))
                    expect(url?.query).to(contain("client_secret="))
                    expect(url?.query).to(contain("v="))
                }

                it("should call resume on task") {
                    let dataTaskSpy = DataTaskSpy()
                    urlSessionStub.dataTask = dataTaskSpy

                    sut.request(type: DummyResponse.self, parameters: [:], completion: { _ in })

                    expect(dataTaskSpy.resumeCalled).to(beTrue())
                }

                it("should cancel previous request") {
                    let dataTaskSpy = DataTaskSpy()
                    urlSessionStub.dataTask = dataTaskSpy

                    sut.request(type: DummyResponse.self, parameters: [:], completion: { _ in })
                    urlSessionStub.dataTask = DataTaskDummy()
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { _ in })

                    expect(dataTaskSpy.cancelCalled).to(beTrue())
                }
            }

            context("callback") {
                it("should response failure when error") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case let .failure(error):
                            expect(error).to(equal(.unknown))
                        case .success:
                            fail()
                        }
                        expectation.fulfill()
                    })
                    urlSessionStub.completion?(nil, nil, NSError(domain: "", code: 404, userInfo: [:]))
                    self.waitForExpectation()
                }

                it("should response failure when no intenet connection") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case let .failure(error):
                            expect(error).to(equal(.noInternetConnection))
                        case .success:
                            fail()
                        }
                        expectation.fulfill()
                    })
                    urlSessionStub.completion?(nil, nil, NSError(domain: "", code: NSURLErrorNotConnectedToInternet, userInfo: [:]))
                    self.waitForExpectation()
                }

                it("should failure if response is nil") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case let .failure(error):
                            expect(error).to(equal(.unknown))
                        case .success:
                            fail()
                        }
                        expectation.fulfill()
                    })
                    urlSessionStub.completion?(nil, nil, nil)
                    self.waitForExpectation()
                }

                it("should failure if status code is different than 2XX") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case let .failure(error):
                            expect(error).to(equal(.unknown))
                        case .success:
                            fail()
                        }
                        expectation.fulfill()
                    })
                    let response = HTTPURLResponse(url: urlSessionStub.request!.url!, statusCode: 400, httpVersion: nil, headerFields: nil)

                    urlSessionStub.completion?(nil, response, nil)
                    self.waitForExpectation()
                }

                it("should failure if status code is 200 but no data") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case let .failure(error):
                            expect(error).to(equal(.unknown))
                        case .success:
                            fail()
                        }
                        expectation.fulfill()
                    })
                    let response = HTTPURLResponse(url: urlSessionStub.request!.url!, statusCode: 200, httpVersion: nil, headerFields: nil)

                    urlSessionStub.completion?(nil, response, nil)
                    self.waitForExpectation()
                }

                it("should success if status code is 200 ") {
                    let expectation = self.expectation(description: "default")
                    sut.request(type: DummyResponse.self, parameters: [:], completion: { response in
                        switch response {
                        case .failure:
                            fail()
                        case let .success(data):
                            expect(data.test).to(equal("test"))
                        }
                        expectation.fulfill()
                    })
                    let data = try? JSONEncoder().encode(DummyResponse(test: "test"))
                    let response = HTTPURLResponse(url: urlSessionStub.request!.url!, statusCode: 200, httpVersion: nil, headerFields: nil)

                    urlSessionStub.completion?(data, response, nil)
                    self.waitForExpectation()
                }
            }
        }
    }

    func waitForExpectation() {
        waitForExpectations(timeout: 3) { error in
            XCTAssertNil(error, "async expectation error")
        }
    }
}

private struct DummyResponse: Codable {
    let test: String
}
