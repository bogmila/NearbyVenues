//
//  LocationServiceSpec.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import CoreLocation
import Nimble
import Quick

@testable import NearbyVenues

class LocationServiceSpec: QuickSpec {
    override func spec() {
        describe("Location Service") {
            var sut: LocationService!
            var locationManagerMock: LocationManagerMock!

            beforeEach {
                locationManagerMock = LocationManagerMock()
                sut = LocationService(locationManager: locationManagerMock)
            }

            it("should set location accuracy") {
                expect(locationManagerMock.desiredAccuracy).to(equal(kCLLocationAccuracyHundredMeters))
            }

            it("should set delegate") {
                expect(locationManagerMock.delegate).to(beIdenticalTo(sut))
            }

            context("location service status") {
                context("when service is not enabled") {
                    beforeEach {
                        locationManagerMock.isServiceEnabled = false
                    }

                    it("should return not allowed when location service is not enabled") {
                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.notAllowed))
                    }
                }

                context("when service is enabled") {
                    beforeEach {
                        locationManagerMock.isServiceEnabled = true
                    }

                    it("should return requested when status is not determined") {
                        locationManagerMock.status = .notDetermined

                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.shouldRequest))
                    }

                    it("should return not allowed when status is restricted") {
                        locationManagerMock.status = .restricted

                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.notAllowed))
                    }

                    it("should return not allowed when status is denied") {
                        locationManagerMock.status = .denied

                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.notAllowed))
                    }

                    it("should return allowed when status is authorized always") {
                        locationManagerMock.status = .authorizedAlways

                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.allowed))
                    }

                    it("should return allowed when status is authorized when in use") {
                        locationManagerMock.status = .authorizedWhenInUse

                        let status = sut.locationServiceStatus()

                        expect(status).to(equal(.allowed))
                    }
                }
            }

            context("request") {
                it("should call request authorization") {
                    sut.request()

                    expect(locationManagerMock.requestWhenInUseAuthorizationCalled).to(beTrue())
                }
            }

            context("start updating location") {
                it("should call start updating location") {
                    sut.startUpdatingLocation()

                    expect(locationManagerMock.startUpdatingLocationCalled).to(beTrue())
                }
            }

            context("delegate methods") {
                var serviceDelegateSpy: LocationServiceDelegateSpy!

                beforeEach {
                    serviceDelegateSpy = LocationServiceDelegateSpy()
                    sut = LocationService(locationManager: LocationManagerDummy())
                    sut.set(delegate: serviceDelegateSpy)
                }

                context("did update location") {
                    it("should call location update success") {
                        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 10.2, longitude: 30.1), altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 0, timestamp: Date())
                        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

                        expect(serviceDelegateSpy.locationUpdateSuccessCalled).to(beTrue())
                        expect(serviceDelegateSpy.location?.latitude).to(equal(10.2))
                        expect(serviceDelegateSpy.location?.longitude).to(equal(30.1))
                    }

                    it("should not call location update success when horrizontal accuracy is negative") {
                        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 10.2, longitude: 30.1), altitude: 0, horizontalAccuracy: -1, verticalAccuracy: 0, timestamp: Date())
                        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

                        expect(serviceDelegateSpy.locationUpdateSuccessCalled).to(beFalse())
                    }
                }

                context("did fail with error") {
                    it("should call location update error") {
                        sut.locationManager(CLLocationManager(), didFailWithError: LocationError.unknown)

                        expect(serviceDelegateSpy.locationUpdateErrorCalled).to(beTrue())
                    }
                }

                context("did change authorization") {
                    it("should call should enable location when status is restricted") {
                        sut.locationManager(CLLocationManager(), didChangeAuthorization: .restricted)

                        expect(serviceDelegateSpy.shouldEnableLocationCalled).to(beTrue())
                    }

                    it("should call should enable location when status is denied") {
                        sut.locationManager(CLLocationManager(), didChangeAuthorization: .denied)

                        expect(serviceDelegateSpy.shouldEnableLocationCalled).to(beTrue())
                    }

                    it("should call authorized when status is authorized always") {
                        sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedAlways)

                        expect(serviceDelegateSpy.authorizedCalled).to(beTrue())
                    }

                    it("should call authorized when status is authorized when in use") {
                        sut.locationManager(CLLocationManager(), didChangeAuthorization: .authorizedWhenInUse)

                        expect(serviceDelegateSpy.authorizedCalled).to(beTrue())
                    }
                }
            }
        }
    }
}

private enum LocationError: Error {
    case unknown
}
