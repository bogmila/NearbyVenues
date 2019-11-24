//
//  LocationManagerBuilder.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
import CoreLocation

enum LocationManagerBuilder {
    static func build() -> LocationManager {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("ui_testing")
        guard isUITesting else { return CLLocationManager() }

        // I would like to use SBTUITestTunnel but after changes locationServicesEnabled and authorizationStatus properties from CLLLocationManager to class functions stubbing location manager in this pod doesn't work
        if ProcessInfo.processInfo.arguments.contains("disabled_location_service") {
            return UITestsLocationManager(locationServicesEnabled: false)
        } else if ProcessInfo.processInfo.arguments.contains("enabled_location_service") {
            return UITestsLocationManager(locationServicesEnabled: true)
        }
        return UITestsLocationManager(locationServicesEnabled: true)
    }
}

private class UITestsLocationManager: LocationManager {
    var delegate: CLLocationManagerDelegate? {
        didSet {
            manager.delegate = delegate
        }
    }

    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer {
        didSet {
            manager.desiredAccuracy = desiredAccuracy
        }
    }

    private let manager = CLLocationManager()
    private var servicesEnabled: Bool = true

    init(locationServicesEnabled: Bool) {
        servicesEnabled = locationServicesEnabled
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        manager.authorizationStatus()
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func locationServicesEnabled() -> Bool {
        return servicesEnabled
    }
}
