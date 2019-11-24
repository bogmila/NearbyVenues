//
//  SearchPresenter.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Foundation

protocol SearchPresenterProtocol {
    func set(viewDelegate: SearchViewDelegate)
    func viewDidLoad()
    func viewDidAppear()
    func didTapTryAgainButton()
    func updateSearchResults(text: String?)
}

class SearchPresenter: SearchPresenterProtocol {
    private let locationService: LocationServiceProtocol
    private let venuesService: VenuesServiceProtocol

    private weak var viewDelegate: SearchViewDelegate?
    private var lastLocation: Location?
    private var lastSearchText: String?

    init(locationService: LocationServiceProtocol = LocationService(), venuesService: VenuesServiceProtocol = VenuesService()) {
        self.locationService = locationService
        self.venuesService = venuesService
    }

    func set(viewDelegate: SearchViewDelegate) {
        self.viewDelegate = viewDelegate
    }

    func viewDidLoad() {
        locationService.set(delegate: self)
    }

    func viewDidAppear() {
        tryFetchVenues()
    }

    func didTapTryAgainButton() {
        tryFetchVenues()
    }
    
    func updateSearchResults(text: String?) {
        if isNilOrEmpty(text: text) && isNilOrEmpty(text: lastSearchText) { return }
        lastSearchText = text
        tryFetchVenues()
    }

    private func tryFetchVenues() {
        if let lastLocation = lastLocation {
            loadNearbyVenues(searchQuery: lastSearchText, location: lastLocation)
        } else {
            startUpdatingLocation()
        }
    }

    private func loadNearbyVenues(searchQuery: String?, location: Location) {
        viewDelegate?.showLoader(message: "Loading venues")
        let parameters = NearbyVenuesRequestParameters(latitude: location.latitude, longitude: location.longitude, query: searchQuery)
        venuesService.fetchNearbyVenues(requestParameters: parameters) { [weak self] response in
            guard let self = self else { return }
            self.viewDelegate?.hideLoader()
            switch response {
            case let .success(data):
                self.showVenues(venues: data.venues)
            case let .failure(error):
                if error == .noInternetConnection {
                    self.viewDelegate?.showNoInternetConnectionMessage()
                } else {
                    self.viewDelegate?.showFetchVenuesErrorAlert()
                }
            }
        }
    }

    private func startUpdatingLocation() {
        switch locationService.locationServiceStatus() {
        case .allowed:
            viewDelegate?.showLoader(message: "Waiting for location")
            locationService.startUpdatingLocation()
        case .notAllowed:
            viewDelegate?.showEnableLocationMessage()
        case .shouldRequest:
            locationService.request()
        }
    }

    private func showVenues(venues: [Venue]) {
        let sortedVenues = venues.sorted { $0.location.distance < $1.location.distance }
        let presentableData: [VenuePresentableData] = sortedVenues.map { venue in
            let distance = self.formattedDistance(distance: venue.location.distance)
            return VenuePresentableData(name: venue.name, address: venue.location.formattedAddress, distance: distance)
        }
        viewDelegate?.show(venues: presentableData)
    }

    private func formattedDistance(distance: Int) -> String {
        if distance < 1000 { return "\(distance) m" }
        return "\(distance / 1000) km"
    }
    
    private func isNilOrEmpty(text: String?) -> Bool {
        return text == nil || text?.isEmpty == true
    }
}

extension SearchPresenter: LocationServiceDelegate {
    func locationUpdateSuccess(location: Location) {
        if lastLocation == nil {
            loadNearbyVenues(searchQuery: lastSearchText, location: location)
        }
        lastLocation = location
    }

    func locationUpdateError() {
        viewDelegate?.showLocationErrorAlert()
    }

    func shouldEnableLocation() {
        viewDelegate?.showEnableLocationMessage()
    }

    func authorized() {
        tryFetchVenues()
    }
}
