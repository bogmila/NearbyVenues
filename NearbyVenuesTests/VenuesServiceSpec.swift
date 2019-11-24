//
//  VenuesServiceSpec.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import Nimble
import Quick

@testable import NearbyVenues

class VenuesServiceSpec: QuickSpec {
    override func spec() {
        describe("Venues Service") {
            var sut: VenuesService!
            var httpServiceMock: HttpServiceSpy<VenueResponse>!

            beforeEach {
                httpServiceMock = HttpServiceSpy()
                sut = VenuesService(httpService: httpServiceMock)
            }

            it("should call http service with correct location") {
                sut.fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters(latitude: 5.0, longitude: 10.0, query: nil)) { _ in }

                expect(httpServiceMock.parameters["ll"]).to(equal("5.0,10.0"))
            }

            it("should call http service with correct query") {
                sut.fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters(latitude: 5.0, longitude: 10.0, query: "sampleQuery")) { _ in }

                expect(httpServiceMock.parameters["query"]).to(equal("sampleQuery"))
            }

            it("should call http service without query") {
                sut.fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters(latitude: 5.0, longitude: 10.0, query: nil)) { _ in }

                expect(httpServiceMock.parameters["query"]).to(beNil())
            }
        }
    }
}
