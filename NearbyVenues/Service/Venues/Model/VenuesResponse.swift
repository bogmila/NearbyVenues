//
//  VenuesResponse.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Foundation

struct VenueResponse: Decodable {
    let venues: [Venue]

    private enum CodingKeys: String, CodingKey {
        case response
    }

    private enum ResponseCodingKeys: String, CodingKey {
        case venues
    }
    
    init(venues: [Venue]) {
        self.venues = venues
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        venues = try resultContainer.decode([Venue].self, forKey: .venues)
    }
}
