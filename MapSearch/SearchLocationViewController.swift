//
//  SearchLocationViewController.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

protocol SearchLocationDelegate: class {
    func didSelectLocation(_ location: Location)
}

final class SearchLocationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var locationsTableView: UITableView!
    @IBOutlet fileprivate weak var emptyView: UIView!
    
    weak var delegate: SearchLocationDelegate?
    var locations = [Location]() {
        didSet {
            locationsTableView.reloadData()
            showEmptyViewIfNeeded()
            locationsTableView.animateFromBottom()
        }
    }
    
    // MARK: - View Controller lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSearchBar()
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapBackgroundView(_ sender: UITapGestureRecognizer) {
        guard !searchBar.isFirstResponder else {
            endEditing()
            return
        }
        dismiss(animated: true)
    }
    
    // MARK: - Fileprivate instance methods
    
    fileprivate func showEmptyViewIfNeeded() {
        let emptySearchBar = (searchBar.text ?? "").isEmpty
        let emptyTableView = locations.count == 0
        emptyView.isHidden = emptySearchBar || !emptyTableView
        locationsTableView.isHidden = emptySearchBar || emptyTableView
        emptyView.animateFromBottom()
    }
    
    fileprivate func endEditing() {
        view.endEditing(true)
        let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton
        cancelButton?.isEnabled = true
    }
    
    fileprivate func configureSearchBar() {
        searchBar.clipsToBounds = true
        searchBar.becomeFirstResponder()
    }
    
    @objc fileprivate func reload() {
        DataManager().searchLocations(query: searchBar.text ?? "") { locations in
            self.locations = locations ?? []
        }
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(reload),
                                               object: nil)
        perform(#selector(reload), with: nil, afterDelay: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing()
    }
}

extension SearchLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Cell.location, for: indexPath) as! LocationTableViewCell
        cell.location = locations[indexPath.row]
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endEditing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        delegate?.didSelectLocation(locations[indexPath.row])
    }
}
