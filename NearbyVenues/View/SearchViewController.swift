//
//  SearchViewController.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import UIKit

class SearchViewController: UIViewController {
    private enum Constants {
        static let cellIdentifier = "VenueTableViewCell"
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var loaderMessage: UILabel!

    private let presenter: SearchPresenterProtocol

    private let searchController = UISearchController(searchResultsController: nil)
    private var messageView: MessageView?

    private var venueList: [VenuePresentableData]?

    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        title = "Nearby venues"
        setupSearchController()
        presenter.set(viewDelegate: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    @IBAction func messageButtonTap(_: Any) {}

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let cell = UINib(nibName: Constants.cellIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return venueList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as! VenueTableViewCell
        guard let item = venueList?[indexPath.row] else { return UITableViewCell() }
        cell.configure(presentable: item)
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateSearchResults(text: searchController.searchBar.text)
    }
}

extension SearchViewController: SearchViewDelegate {
    func hideLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loaderMessage.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func show(venues: [VenuePresentableData]) {
        venueList = venues
        if venues.isEmpty {
            showFullScreenMessageView(title: "No results found", description: "Try rewording your search or entering new keyword.")
        } else {
            tableView.isHidden = false
        }
        tableView.reloadData()
    }

    func showFetchVenuesErrorAlert() {
        let alertController = UIAlertController(title: "Oops", message: "Fetching venues failed.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        present(alertController, animated: true)
    }

    func showLoader(message: String?) {
        resetView()
        if venueList?.isEmpty != false {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            loaderMessage.isHidden = false
            loaderMessage.text = message
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func showEnableLocationMessage() {
        showFullScreenMessageView(title: "Location services disabled", description: "Please enable location services for this application.")
        disableSearch()
    }

    func showNoInternetConnectionMessage() {
        showFullScreenMessageView(title: "No Internet connection", description: "Make sure that Wi-Fi or mobile data is turned on.", actionTitle: "Try again", action: { [weak self] in
            self?.presenter.didTapTryAgainButton()
        })
    }

    func showLocationErrorAlert() {
        let alertController = UIAlertController(title: "Oops", message: "Something went wrong with location.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        present(alertController, animated: true)
    }

    private func showFullScreenMessageView(title: String, description: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        let messageView = MessageView()
        messageView.setup(title: title, description: description, actionTitle: actionTitle, action: action)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        self.messageView = messageView
        view.addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: view.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableView.isHidden = true
    }

    private func resetView() {
        removeMessageView()
        enableSearch()
    }

    private func removeMessageView() {
        messageView?.removeFromSuperview()
        messageView = nil
    }

    private func enableSearch() {
        searchController.searchBar.placeholder = "Type something to search"
        searchController.searchBar.isUserInteractionEnabled = true
    }

    private func disableSearch() {
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.placeholder = nil
    }
}
