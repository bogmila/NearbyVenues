//
//  SearchViewDelegateDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//
@testable import NearbyVenues

final class SearchViewDelegateSpy: SearchViewDelegate {
    private(set) var hideLoaderCalled = false
    private(set) var showCalled = false
    private(set) var showVenues: [VenuePresentableData]?
    private(set) var showLoaderCalled = false
    private(set) var showLoaderMessage: String?
    private(set) var showEnableLocationMessageCalled = false
    private(set) var showLocationErrorAlertCalled = false
    private(set) var showFetchVenuesErrorAlertCalled = false
    private(set) var showEmptyListMessageCalled = false
    private(set) var showNoInternetConnectionMessageCalled = false
    
    func hideLoader() {
        hideLoaderCalled = true
    }

    func show(venues: [VenuePresentableData]) {
        showCalled = true
        showVenues = venues
    }

    func showLoader(message: String?) {
        showLoaderCalled = true
        showLoaderMessage = message
    }

    func showEnableLocationMessage() {
        showEnableLocationMessageCalled = true
    }

    func showLocationErrorAlert() {
        showLocationErrorAlertCalled = true
    }

    func showFetchVenuesErrorAlert() {
        showFetchVenuesErrorAlertCalled = true
    }
    func showEmptyListMessage() {
        showEmptyListMessageCalled = true
     }
     
     func showNoInternetConnectionMessage() {
         showNoInternetConnectionMessageCalled = true
     }
     

    func reset() {
        hideLoaderCalled = false
        showCalled = false
        showVenues = nil
        showLoaderCalled = false
        showLoaderMessage = nil
        showEnableLocationMessageCalled = false
        showLocationErrorAlertCalled = false
        showFetchVenuesErrorAlertCalled = false
    }
}
