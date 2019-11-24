//
//  SearchViewControllerBuilder.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//

import CoreLocation
import UIKit

enum SearchViewControllerBuilder {
    // some dependency container can be used
    static func build() -> SearchViewController {
        let locationManager: LocationManager = LocationManagerBuilder.build()
        let locationService = LocationService(locationManager: locationManager)
        let venuesService = VenuesService(httpService: HttpService(session: URLSession.shared))
        let presenter = SearchPresenter(locationService: locationService, venuesService: venuesService)
        return SearchViewController(presenter: presenter)
    }
}
