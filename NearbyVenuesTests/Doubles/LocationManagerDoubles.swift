//
//  LocationManagerDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//
import CoreLocation
@testable import NearbyVenues

final class LocationManagerDummy: LocationManager {
    var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer
    func locationServicesEnabled() -> Bool {
        return true
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedAlways
    }

    func requestWhenInUseAuthorization() {}
    
    func startUpdatingLocation() {}
}

final class LocationManagerMock: LocationManager {
    var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer

    var isServiceEnabled = true
    var status: CLAuthorizationStatus = .authorizedAlways

    private(set) var requestWhenInUseAuthorizationCalled = false
    private(set) var startUpdatingLocationCalled = false

    func locationServicesEnabled() -> Bool {
        return isServiceEnabled
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        return status
    }

    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCalled = true
    }

    func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }
}
