//
//  SearchViewDelegate.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

protocol SearchViewDelegate: AnyObject {
    func hideLoader()
    func show(venues: [VenuePresentableData])
    func showLoader(message: String?)
    func showEnableLocationMessage()
    func showNoInternetConnectionMessage()
    func showLocationErrorAlert()
    func showFetchVenuesErrorAlert()
}
