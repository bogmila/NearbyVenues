//
//  VenuesServiceDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//
@testable import NearbyVenues

final class VenuesServiceDummy: VenuesServiceProtocol {
    func fetchNearbyVenues(requestParameters _: NearbyVenuesRequestParameters, completion _: @escaping (Result<VenueResponse, NetworkError>) -> Void) {}
}

class VenuesServiceSpy: VenuesServiceProtocol {
    private(set) var fetchNearbyVenuesCalled = false
    private(set) var requestParameters: NearbyVenuesRequestParameters?

    func fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters, completion _: @escaping (Result<VenueResponse, NetworkError>) -> Void) {
        fetchNearbyVenuesCalled = true
        self.requestParameters = requestParameters
    }

    func reset() {
        fetchNearbyVenuesCalled = false
        requestParameters = nil
    }
}

final class VenuesServiceStub: VenuesServiceSpy {
    private(set) var completion: ((Result<VenueResponse, NetworkError>) -> Void)?
    override func fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters, completion: @escaping (Result<VenueResponse, NetworkError>) -> Void) {
        super.fetchNearbyVenues(requestParameters: requestParameters, completion: completion)
        self.completion = completion
    }
}
