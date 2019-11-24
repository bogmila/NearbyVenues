//
//  NearbyVenuesUITests.swift
//  NearbyVenuesUITests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Nimble
import Quick
import SBTUITestTunnelClient
import XCTest


class NearbyVenuesUITests: QuickSpec {
    enum Constants {
        static let serviceTimeout: TimeInterval = 10
    }

    override func spec() {
        beforeEach {
            self.continueAfterFailure = false
            self.app.launchArguments.append("ui_testing")
        }

        afterEach {
            self.app.terminate()
        }

        context("location service is not enabled") {
            beforeEach {
                self.app.launchArguments.append("disabled_location_service")
            }

            it("should show disabled location message") {
                self.app.launch()

                expect(self.app.staticTexts["Location services disabled"].exists).to(beTrue())
                expect(self.app.staticTexts["Please enable location services for this application."].exists).to(beTrue())
            }
        }

        context("location service is enabled") {
            beforeEach {
                self.app.launchArguments.append("enabled_location_service")
            }

            context("authorization status is not determined") {
                // I am testing only positive path with "Allow once" option for request location manager because I can not find solution to restart user permission between test use cases.
                beforeEach {
                    guard let responseData = MockApiResponseProvider.loadAsData("response.json") else { return }
                    let response = SBTStubResponse(response: responseData)
                    self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                }

                it("should show locations list when api response is correct") {
                    self.app.launchTunnel {
                        guard let responseData = MockApiResponseProvider.loadAsData("response.json") else { return }
                        let response = SBTStubResponse(response: responseData)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    expect(self.app.staticTexts["Mr. Purple"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["180 Orchard St (btwn Houston & Stanton St)"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["New York, NY 10002"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["United States"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["8 m"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }
                
                it("should show error when api response is wrong") {
                    self.app.launchTunnel {
                        let response = SBTStubResponse(response: ["key": "value"])
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    expect(self.app.staticTexts["Oops"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["Fetching venues failed."].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }

                it("should show error when api response status code is different than 2xx") {
                    self.app.launchTunnel {
                        let response = SBTStubResponse(response: [:], returnCode: 400)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    expect(self.app.staticTexts["Oops"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["Fetching venues failed."].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }

                it("should show empty list message") {
                    self.app.launchTunnel {
                        guard let responseData = MockApiResponseProvider.loadAsData("empty_response.json") else { return }
                        let response = SBTStubResponse(response: responseData)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    expect(self.app.staticTexts["No results found"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["Try rewording your search or entering new keyword."].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }

                it("should show search result") {
                    self.app.launchTunnel {
                        let response = SBTStubResponse(response: MockApiResponseProvider.loadAsData("response.json")!)
                        let aResponse = SBTStubResponse(response: MockApiResponseProvider.loadAsData("a_search_response.json")!)
                        let abResponse = SBTStubResponse(response: MockApiResponseProvider.loadAsData("ab_search_response.json")!)
                        let emptyResponse = SBTStubResponse(response: MockApiResponseProvider.loadAsData("empty_response.json")!)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search", query: ["&query=a"]), response: aResponse)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search", query: ["&query=ab"]), response: abResponse)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search", query: ["&query=abc"]), response: emptyResponse)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    self.waitFor(self.app.staticTexts["Mr. Purple"])

                    let nearbyVenuesNavigationBar = self.app.navigationBars["Nearby venues"]
                    nearbyVenuesNavigationBar.searchFields["Type something to search"].tap()
                    nearbyVenuesNavigationBar.searchFields["Type something to search"].typeText("a")

                    expect(self.app.staticTexts["a venue"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["ab venue"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)

                    nearbyVenuesNavigationBar.searchFields["Type something to search"].typeText("b")
                    expect(self.app.staticTexts["a venue"].exists).toEventually(beFalse(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["ab venue"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)

                    nearbyVenuesNavigationBar.searchFields["Type something to search"].typeText("c")
                    expect(self.app.staticTexts["No results found"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["Try rewording your search or entering new keyword."].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }
                it("should show start venue list after search cancel") {
                    self.app.launchTunnel {
                        let response = SBTStubResponse(response: MockApiResponseProvider.loadAsData("response.json")!)
                        let aResponse = SBTStubResponse(response: MockApiResponseProvider.loadAsData("a_search_response.json")!)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search"), response: response)
                        self.app.stubRequests(matching: SBTRequestMatch(url: "https://api.foursquare.com/v2/venues/search", query: ["&query=a"]), response: aResponse)
                    }
                    self.addUIInterruptionMonitor(withDescription: "Allow “NearbyVenues” to access your location?") { alert in
                        alert.buttons["Allow Once"].tap()
                        return true
                    }
                    self.app.tap()

                    self.waitFor(self.app.staticTexts["Mr. Purple"])

                    let nearbyVenuesNavigationBar = self.app.navigationBars["Nearby venues"]
                    nearbyVenuesNavigationBar.searchFields["Type something to search"].tap()
                    nearbyVenuesNavigationBar.searchFields["Type something to search"].typeText("a")

                    expect(self.app.staticTexts["a venue"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["ab venue"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)

                    nearbyVenuesNavigationBar.buttons["Cancel"].tap()
                    expect(self.app.staticTexts["Mr. Purple"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["180 Orchard St (btwn Houston & Stanton St)"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["New York, NY 10002"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["United States"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                    expect(self.app.staticTexts["8 m"].exists).toEventually(beTrue(), timeout: Constants.serviceTimeout)
                }
            }
        }
    }

    func waitFor(_ element: XCUIElement, timeout: TimeInterval = 60) {
        let existPredicate = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: element)
        _ = XCTWaiter.wait(for: [existPredicate], timeout: timeout)
    }
}
