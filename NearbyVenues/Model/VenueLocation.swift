//
//  VenueLocation.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Foundation

struct VenueLocation: Decodable {
    let distance: Int
    let formattedAddress: [String]
}
