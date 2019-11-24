//
//  SearchPresenterDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
@testable import NearbyVenues

final class SearchPresenterSpy: SearchPresenterProtocol {
    private(set) var setCalled = false
    private(set) var setViewDelegate: SearchViewDelegate?
    private(set) var viewDidLoadCalled = false
    private(set) var viewDidAppearCalled = false
    private(set) var updateSearchResultsCalled = false
    private(set) var updateSearchResultsText: String?
    private(set) var didTapTryAgainButtonCalled = false

    func set(viewDelegate: SearchViewDelegate) {
        setCalled = true
        setViewDelegate = viewDelegate
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func viewDidAppear() {
        viewDidAppearCalled = true
    }

    func updateSearchResults(text: String?) {
        updateSearchResultsCalled = true
        updateSearchResultsText = text
    }

    func didTapTryAgainButton() {
        didTapTryAgainButtonCalled = false
    }
}
