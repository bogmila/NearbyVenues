//
//  SerachPresenterSpec.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import Nimble
import Quick

@testable import NearbyVenues

class SearchPresenterSpec: QuickSpec {
    override func spec() {
        describe("Search Presenter") {
            var sut: SearchPresenter!

            context("calling view did load") {
                it("should set delegate on location service") {
                    let locationServiceSpy = LocationServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceSpy, venuesService: VenuesServiceDummy())

                    sut.viewDidLoad()

                    expect(locationServiceSpy.delegate).to(beIdenticalTo(sut))
                }
            }

            context("calling view did appear") {
                var locationServiceStub: LocationServiceStub!
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                context("when location was not set before") {
                    context("when location service is not allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .notAllowed
                        }

                        it("should show enable location message") {
                            sut.viewDidAppear()

                            expect(viewDelegateSpy.showEnableLocationMessageCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.viewDidAppear()

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }

                    context("when location service is allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .allowed
                        }

                        it("should show loader") {
                            sut.viewDidAppear()

                            expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                            expect(viewDelegateSpy.showLoaderMessage).to(equal("Waiting for location"))
                        }

                        it("should start updatig location") {
                            sut.viewDidAppear()

                            expect(locationServiceStub.startUpdatingLocationCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.viewDidAppear()

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }

                    context("when location service should request") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .shouldRequest

                            sut.viewDidAppear()

                            expect(locationServiceStub.requestCalled).to(beTrue())
                        }
                    }
                }

                context("when location was set before") {
                    beforeEach {
                        sut.locationUpdateSuccess(location: Location(latitude: 44.0, longitude: 10.5))
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                        venuesServiceSpy.reset()
                    }

                    it("should call fetch venues with correct location") {
                        sut.viewDidAppear()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(44.0))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.5))
                    }

                    it("should call fetch venues without query") {
                        sut.viewDidAppear()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.query).to(beNil())
                    }

                    it("should call fetch venues with query if query was set before") {
                        sut.updateSearchResults(text: "query")
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                        venuesServiceSpy.reset()

                        sut.viewDidAppear()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.query).to(equal("query"))
                    }

                    it("should show loader") {
                        sut.viewDidAppear()

                        expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                        expect(viewDelegateSpy.showLoaderMessage).to(equal("Loading venues"))
                    }

                    it("shouldn't start updating location") {
                        sut.viewDidAppear()

                        expect(locationServiceStub.startUpdatingLocationCalled).to(beFalse())
                    }
                }
            }

            context("call update search results") {
                var locationServiceStub: LocationServiceStub!
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                context("when location was not set before") {
                    context("when location service is not allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .notAllowed
                        }

                        it("should show enable location message") {
                            sut.updateSearchResults(text: "query")

                            expect(viewDelegateSpy.showEnableLocationMessageCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.updateSearchResults(text: "query")

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }

                    context("when location service is allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .allowed
                        }

                        it("should show loader") {
                            sut.updateSearchResults(text: "query")

                            expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                            expect(viewDelegateSpy.showLoaderMessage).to(equal("Waiting for location"))
                        }

                        it("should start updatig location") {
                            sut.updateSearchResults(text: "query")

                            expect(locationServiceStub.startUpdatingLocationCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.updateSearchResults(text: "query")

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }
                }

                context("when location was set before set") {
                    beforeEach {
                        sut.locationUpdateSuccess(location: Location(latitude: 44.0, longitude: 10.5))
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                    }

                    it("should call fetch venues with correct location") {
                        sut.updateSearchResults(text: "query")

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(44.0))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.5))
                    }

                    it("should call fetch venues with query") {
                        sut.updateSearchResults(text: "query")

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.query).to(equal("query"))
                    }

                    it("should show loader") {
                        sut.updateSearchResults(text: "query")

                        expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                        expect(viewDelegateSpy.showLoaderMessage).to(equal("Loading venues"))
                    }

                    it("shouldn't start updating location") {
                        sut.updateSearchResults(text: "query")

                        expect(locationServiceStub.startUpdatingLocationCalled).to(beFalse())
                    }
                }

                it("should set search text for next fetching") {
                    sut.locationUpdateSuccess(location: Location(latitude: 44.0, longitude: 10.5))
                    sut.updateSearchResults(text: "query")
                    viewDelegateSpy.reset()
                    locationServiceStub.reset()
                    venuesServiceSpy.reset()
                    locationServiceStub.serviceStatus = .allowed

                    sut.viewDidAppear()

                    expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                    expect(venuesServiceSpy.requestParameters?.query).to(equal("query"))
                }
            }

            context("call authorized") {
                var locationServiceStub: LocationServiceStub!
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                context("when location was not set before") {
                    it("should show loader") {
                        sut.authorized()

                        expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                        expect(viewDelegateSpy.showLoaderMessage).to(equal("Waiting for location"))
                    }

                    it("should start updatig location") {
                        sut.authorized()

                        expect(locationServiceStub.startUpdatingLocationCalled).to(beTrue())
                    }
                }

                context("when location was set before set") {
                    beforeEach {
                        sut.locationUpdateSuccess(location: Location(latitude: 44.0, longitude: 10.5))
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                    }

                    it("should call fetch venues with correct location") {
                        sut.authorized()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(44.0))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.5))
                    }

                    it("should show loader") {
                        sut.authorized()

                        expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                        expect(viewDelegateSpy.showLoaderMessage).to(equal("Loading venues"))
                    }
                }
            }

            context("call did tap try again button") {
                var locationServiceStub: LocationServiceStub!
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                context("when location was not set before") {
                    context("when location service is not allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .notAllowed
                        }

                        it("should show enable location message") {
                            sut.didTapTryAgainButton()

                            expect(viewDelegateSpy.showEnableLocationMessageCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.didTapTryAgainButton()

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }

                    context("when location service is allowed") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .allowed
                        }

                        it("should show loader") {
                            sut.didTapTryAgainButton()

                            expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                            expect(viewDelegateSpy.showLoaderMessage).to(equal("Waiting for location"))
                        }

                        it("should start updatig location") {
                            sut.didTapTryAgainButton()

                            expect(locationServiceStub.startUpdatingLocationCalled).to(beTrue())
                        }

                        it("shouldn't fetch venues") {
                            sut.didTapTryAgainButton()

                            expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                        }
                    }

                    context("when location service should request") {
                        beforeEach {
                            locationServiceStub.serviceStatus = .shouldRequest

                            sut.didTapTryAgainButton()

                            expect(locationServiceStub.requestCalled).to(beTrue())
                        }
                    }
                }

                context("when location was set before") {
                    beforeEach {
                        sut.locationUpdateSuccess(location: Location(latitude: 44.0, longitude: 10.5))
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                        venuesServiceSpy.reset()
                    }

                    it("should call fetch venues with correct location") {
                        sut.didTapTryAgainButton()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(44.0))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.5))
                    }

                    it("should call fetch venues without query") {
                        sut.didTapTryAgainButton()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.query).to(beNil())
                    }

                    it("should call fetch venues with query if query was set before") {
                        sut.updateSearchResults(text: "query")
                        locationServiceStub.reset()
                        viewDelegateSpy.reset()
                        venuesServiceSpy.reset()

                        sut.didTapTryAgainButton()

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beTrue())
                        expect(venuesServiceSpy.requestParameters?.query).to(equal("query"))
                    }

                    it("should show loader") {
                        sut.didTapTryAgainButton()

                        expect(viewDelegateSpy.showLoaderCalled).to(beTrue())
                        expect(viewDelegateSpy.showLoaderMessage).to(equal("Loading venues"))
                    }

                    it("shouldn't start updating location") {
                        sut.didTapTryAgainButton()

                        expect(locationServiceStub.startUpdatingLocationCalled).to(beFalse())
                    }
                }
            }

            context("call location update succes") {
                var locationServiceStub: LocationServiceStub!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceSpy)
                }

                context("when location was set before") {
                    beforeEach {
                        sut.locationUpdateSuccess(location: Location(latitude: 20.3, longitude: 30.2))
                        locationServiceStub.reset()
                        venuesServiceSpy.reset()
                    }

                    it("shouldn't fetch venues") {
                        sut.locationUpdateSuccess(location: Location(latitude: 40.1, longitude: 10.4))

                        expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                    }

                    it("should save new location for next fetching") {
                        sut.locationUpdateSuccess(location: Location(latitude: 40.1, longitude: 10.4))

                        sut.viewDidAppear()

                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(40.1))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.4))
                    }
                }

                context("when location wasn't set before") {
                    it("should fetch venues with correct location") {
                        sut.locationUpdateSuccess(location: Location(latitude: 40.1, longitude: 10.4))

                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(40.1))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.4))
                    }

                    it("should fetch venues without query") {
                        sut.locationUpdateSuccess(location: Location(latitude: 40.1, longitude: 10.4))

                        expect(venuesServiceSpy.requestParameters?.query).to(beNil())
                    }

                    it("should set new location for next fetching") {
                        sut.locationUpdateSuccess(location: Location(latitude: 40.1, longitude: 10.4))
                        locationServiceStub.reset()
                        venuesServiceSpy.reset()

                        sut.viewDidAppear()

                        expect(venuesServiceSpy.requestParameters?.latitude).to(equal(40.1))
                        expect(venuesServiceSpy.requestParameters?.longitude).to(equal(10.4))
                    }
                }
            }

            context("call location update error") {
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: LocationServiceDummy(), venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                it("should show location error") {
                    sut.locationUpdateError()

                    expect(viewDelegateSpy.showLocationErrorAlertCalled).to(beTrue())
                }

                it("shouldn't fetch venues") {
                    sut.locationUpdateError()

                    expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                }
            }

            context("call should enable location") {
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceSpy: VenuesServiceSpy!

                beforeEach {
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceSpy = VenuesServiceSpy()
                    sut = SearchPresenter(locationService: LocationServiceDummy(), venuesService: venuesServiceSpy)
                    sut.set(viewDelegate: viewDelegateSpy)
                }

                it("should show enable location message") {
                    sut.shouldEnableLocation()

                    expect(viewDelegateSpy.showEnableLocationMessageCalled).to(beTrue())
                }

                it("shouldn't fetch venues") {
                    sut.locationUpdateError()

                    expect(venuesServiceSpy.fetchNearbyVenuesCalled).to(beFalse())
                }
            }

            context("fetching venues callback") {
                var locationServiceStub: LocationServiceStub!
                var viewDelegateSpy: SearchViewDelegateSpy!
                var venuesServiceStub: VenuesServiceStub!
                let venuesList = [Venue(name: "venue", location: VenueLocation(distance: 5, formattedAddress: ["line 1", "line 2"]))]
                let venueResponse = VenueResponse(venues: venuesList)

                beforeEach {
                    locationServiceStub = LocationServiceStub()
                    viewDelegateSpy = SearchViewDelegateSpy()
                    venuesServiceStub = VenuesServiceStub()
                    sut = SearchPresenter(locationService: locationServiceStub, venuesService: venuesServiceStub)
                    sut.set(viewDelegate: viewDelegateSpy)
                    locationServiceStub.serviceStatus = .allowed
                }

                it("sholud hide loader when success") {
                    sut.locationUpdateSuccess(location: Location(latitude: 40.5, longitude: 12.2))
                    venuesServiceStub.completion?(.success(venueResponse))

                    expect(viewDelegateSpy.hideLoaderCalled).to(beTrue())
                }

                it("should show venues when success") {
                    sut.locationUpdateSuccess(location: Location(latitude: 40.5, longitude: 12.2))
                    venuesServiceStub.completion?(.success(venueResponse))

                    expect(viewDelegateSpy.showCalled).to(beTrue())
                    expect(viewDelegateSpy.showVenues?.count).to(equal(1))
                    expect(viewDelegateSpy.showVenues?.first?.name).to(equal("venue"))
                    expect(viewDelegateSpy.showVenues?.first?.distance).to(equal("5 m"))
                    expect(viewDelegateSpy.showVenues?.first?.address[0]).to(equal("line 1"))
                    expect(viewDelegateSpy.showVenues?.first?.address[1]).to(equal("line 2"))
                }

                it("should show error when failure") {
                    sut.locationUpdateSuccess(location: Location(latitude: 40.5, longitude: 12.2))
                    venuesServiceStub.completion?(.failure(.unknown))

                    expect(viewDelegateSpy.showFetchVenuesErrorAlertCalled).to(beTrue())
                }

                it("should show message when no internet connection") {
                    sut.locationUpdateSuccess(location: Location(latitude: 40.5, longitude: 12.2))
                    venuesServiceStub.completion?(.failure(.noInternetConnection))

                    expect(viewDelegateSpy.showNoInternetConnectionMessageCalled).to(beTrue())
                }

                it("sholud hide loader when failure") {
                    sut.locationUpdateSuccess(location: Location(latitude: 40.5, longitude: 12.2))
                    venuesServiceStub.completion?(.failure(.unknown))

                    expect(viewDelegateSpy.hideLoaderCalled).to(beTrue())
                }
            }
        }
    }
}
