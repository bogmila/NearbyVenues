//
//  LocationManager.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import CoreLocation

protocol LocationManager: AnyObject {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func locationServicesEnabled() -> Bool
    func authorizationStatus() -> CLAuthorizationStatus
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
}

extension CLLocationManager: LocationManager {
    func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
