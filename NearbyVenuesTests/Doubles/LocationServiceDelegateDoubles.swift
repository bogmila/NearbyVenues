//
//  LocationServiceDelegateDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
@testable import NearbyVenues

final class LocationServiceDelegateSpy: LocationServiceDelegate {
    private(set) var location: Location?
    private(set) var locationUpdateSuccessCalled = false
    private(set) var locationUpdateErrorCalled = false
    private(set) var shouldEnableLocationCalled = false
    private(set) var authorizedCalled = false

    func locationUpdateSuccess(location: Location) {
        self.location = location
        locationUpdateSuccessCalled = true
    }

    func locationUpdateError() {
        locationUpdateErrorCalled = true
    }

    func shouldEnableLocation() {
        shouldEnableLocationCalled = true
    }

    func authorized() {
        authorizedCalled = true
    }
}

