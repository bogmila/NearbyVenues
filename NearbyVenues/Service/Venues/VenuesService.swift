//
//  VenuesService.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//
import Foundation

protocol VenuesServiceProtocol {
    func fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters, completion: @escaping (Result<VenueResponse, NetworkError>) -> Void)
}

final class VenuesService: VenuesServiceProtocol {
    private let httpService: HttpServiceProtocol

    init(httpService: HttpServiceProtocol = HttpService()) {
        self.httpService = httpService
    }

    func fetchNearbyVenues(requestParameters: NearbyVenuesRequestParameters, completion: @escaping (Result<VenueResponse, NetworkError>) -> Void) {
        var parameters = ["ll": "\(requestParameters.latitude),\(requestParameters.longitude)"]
        parameters["query"] = requestParameters.query

        httpService.request(type: VenueResponse.self, parameters: parameters, completion: completion)
    }
}
