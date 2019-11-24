//
//  SearchViewControllerSpec.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

import Nimble
import Quick

@testable import NearbyVenues

class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Search View Controller") {
            var sut: SearchViewController!
            var presenterSpy: SearchPresenterSpy!

            beforeEach {
                presenterSpy = SearchPresenterSpy()
                sut = SearchViewController(presenter: presenterSpy)
                sut.beginAppearanceTransition(true, animated: false)
                sut.endAppearanceTransition()
            }

            context("view did load") {
                it("should set view delegate on presenter") {
                    sut.viewDidLoad()

                    expect(presenterSpy.setCalled).to(beTrue())
                    expect(presenterSpy.setViewDelegate).to(beIdenticalTo(sut))
                }

                it("should call view did load on presenter") {
                    sut.viewDidLoad()

                    expect(presenterSpy.viewDidLoadCalled).to(beTrue())
                }
            }

            context("view did appear") {
                it("should call view did appear on presenter") {
                    sut.viewDidLoad()

                    expect(presenterSpy.viewDidAppearCalled).to(beTrue())
                }
            }

            context("update search results") {
                it("should call update search result on presenter") {
                    let searchController = UISearchController(searchResultsController: nil)
                    searchController.searchBar.text = "query"

                    sut.updateSearchResults(for: searchController)

                    expect(presenterSpy.updateSearchResultsCalled).to(beTrue())
                    expect(presenterSpy.updateSearchResultsText).to(equal("query"))
                }
            }
        }
    }
}
