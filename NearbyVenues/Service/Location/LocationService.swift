//
//  LocationService.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import CoreLocation

protocol LocationServiceProtocol {
    func set(delegate: LocationServiceDelegate)
    func locationServiceStatus() -> LocationServiceStatus
    func startUpdatingLocation()
    func request()
}

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager: LocationManager
    private weak var delegate: LocationServiceDelegate?
    private var lastLocation: Location?

    init(locationManager: LocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func set(delegate: LocationServiceDelegate) {
        self.delegate = delegate
    }

    func locationServiceStatus() -> LocationServiceStatus {
        if locationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus() {
            case .notDetermined:
                return .shouldRequest
            case .restricted, .denied:
                return .notAllowed
            case .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            @unknown default:
                print("Unknown authorization status")
                return .notAllowed
            }
        } else {
            print("Location services are not enabled")
            return .notAllowed
        }
    }

    func request() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy >= 0 else { return }
        let currentLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        delegate?.locationUpdateSuccess(location: currentLocation)
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
        delegate?.locationUpdateError()
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            delegate?.shouldEnableLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.authorized()
        default: ()
        }
    }
}
