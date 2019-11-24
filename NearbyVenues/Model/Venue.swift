//
//  Venue.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Foundation

struct Venue: Decodable {
    let name: String
    let location: VenueLocation
}
