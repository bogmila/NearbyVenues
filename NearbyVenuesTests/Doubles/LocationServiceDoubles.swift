//
//  LoactionServiceDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//
@testable import NearbyVenues

final class LocationServiceDummy: LocationServiceProtocol {
    func request() {}

    func set(delegate _: LocationServiceDelegate) {}

    func locationServiceStatus() -> LocationServiceStatus {
        return .allowed
    }

    func startUpdatingLocation() {}
}

class LocationServiceSpy: LocationServiceProtocol {
    private(set) var delegate: LocationServiceDelegate?
    private(set) var startUpdatingLocationCalled = false
    private(set) var requestCalled = false

    func set(delegate: LocationServiceDelegate) {
        self.delegate = delegate
    }

    func locationServiceStatus() -> LocationServiceStatus {
        return .allowed
    }

    func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }

    func request() {
        requestCalled = true
    }

    func reset() {
        delegate = nil
        startUpdatingLocationCalled = false
    }
}

final class LocationServiceStub: LocationServiceSpy {
    var serviceStatus: LocationServiceStatus?

    override func set(delegate: LocationServiceDelegate) {
        super.set(delegate: delegate)
    }

    override func locationServiceStatus() -> LocationServiceStatus {
        return serviceStatus ?? super.locationServiceStatus()
    }

    override func startUpdatingLocation() {
        super.startUpdatingLocation()
    }

    override func reset() {
        super.reset()
        serviceStatus = nil
    }
}
