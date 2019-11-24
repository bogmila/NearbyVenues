//
//  HttpServiceDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//

import Foundation
@testable import NearbyVenues

class HttpServiceSpy<U: Decodable>: HttpServiceProtocol {
    private(set) var parameters: [String: String] = [:]

    func request<T: Decodable>(type _: T.Type, parameters: [String: String], completion _: @escaping (Result<T, NetworkError>) -> Void) {
        self.parameters = parameters
    }
}
