//
//  DetailViewController.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit
import CoreLocation

final class MapViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var mapView: MapView!
    @IBOutlet fileprivate weak var locationDetailView: UIView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var streetLabel: UILabel!
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var mapViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var mapViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var mapViewLeadingConstraint: NSLayoutConstraint!
    fileprivate let locationManager = CLLocationManager()
    
    var location: Location? {
        didSet {
            updateLocation()
        }
    }
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsToFitScreen()
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func didTouchUpInsideSearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: R.Segue.showSearchBar, sender: self)
    }
    
    @IBAction fileprivate func didTouchUpInsideCurrentButton(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    // MARK: - Fileprivate instance methods
    
    fileprivate func updateConstraintsToFitScreen() {
        let window = UIApplication.shared.keyWindow
        let topPadding = UIApplication.shared.statusBarFrame.height
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let leftPadding = window?.safeAreaInsets.left ?? 0
        let rightPadding = window?.safeAreaInsets.right ?? 0
        UIView.animate(withDuration: 0.2) {
            self.mapViewBottomConstraint.constant = -bottomPadding
            self.mapViewTopConstraint.constant = topPadding
            self.mapViewLeadingConstraint.constant = -leftPadding
            self.mapViewTrailingConstraint.constant = -rightPadding
        }
    }
    
    fileprivate func showCurrentLocation() {
        locationDetailView.isHidden = true
        askForLocationPermission()
    }
    
    fileprivate func updateLocation() {
        storeLocation()
        updateLocationDetailView()
    }
    
    fileprivate func storeLocation() {
        guard let location = location else {
            return
        }
        DataManager().storeLocation(location)
    }
    
    fileprivate func askForLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func zoomToLocation(coordinate: (latitude: Double?, longitude: Double?),
                                    zoom: Double? = nil) {
        guard let latitude = coordinate.latitude, let longitude = coordinate.longitude else {
            return
        }
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: latitude,
                                                 longitude: longitude),
                          zoomLevel: zoom)
    }
    
    fileprivate func updateLocationDetailView() {
        guard let location = location else {
            locationDetailView.isHidden = true
            return
        }
        nameLabel.text = location.name
        streetLabel.text = location.printableStreet
        cityLabel.text = location.printableCity
        locationDetailView.isHidden = false
        locationDetailView.animateFromBottom(delay: 0.5)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.Segue.showSearchBar,
            let vc = segue.destination as? SearchLocationViewController {
            vc.delegate = self
        }
    }

}

extension MapViewController: MapViewDelegate {
    
    func regionWillChange() {
        locationDetailView.hideFromTop()
    }
    
    func regionDidChange(latitude: Double, longitude: Double) {
        DataManager().getLocation(coordinate: (mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude)) { location in
            self.location = location
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        DataManager().getLocation(coordinate: (locValue.latitude, locValue.longitude)) { location in
            self.zoomToLocation(coordinate: (latitude: location?.latitude, longitude: location?.longitude))
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlertLocation(title: R.String.locationFailed)
    }
}

extension MapViewController: SearchLocationDelegate {
    
    func didSelectLocation(_ location: Location) {
        zoomToLocation(coordinate: (latitude: location.latitude, longitude: location.longitude))
    }
}

