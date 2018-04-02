//
//  DetailViewController.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit
import Mapbox

final class MapViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var mapView: MGLMapView!
    @IBOutlet fileprivate weak var locationDetailView: UIView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var streetLabel: UILabel!
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    var location: Location? {
        didSet {
            showLocation()
        }
    }
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocation()
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func didTouchUpInsideSearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: R.Segue.showSearchBar, sender: self)
    }
    
    @IBAction fileprivate func didTouchUpInsideCurrentButton(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    // MARK: - Fileprivate instance methods
    
    fileprivate func showCurrentLocation() {
        locationDetailView.isHidden = true
        askForLocationPermission()
    }
    
    fileprivate func showLocation() {
        locationDetailView.isHidden = false
        updateLocationView()
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
                          zoomLevel: zoom ?? mapView.zoomLevel, animated: true)
    }
    
    fileprivate func updateLocationView() {
        guard let location = location else {
            locationDetailView.isHidden = true
            return
        }
        nameLabel.text = location.name
        
        switch (location.street, location.number) {
        case (.some, .some):
            streetLabel.text = "\(location.number ?? ""), \(location.street ?? "")"
        case (.some, .none):
            streetLabel.text = "\(location.street ?? "")"
        default:
            streetLabel.text = nil
        }
        
        switch (location.postalCode, location.city) {
        case (.some, .some):
            cityLabel.text = "\(location.postalCode ?? ""), \(location.city ?? "")"
        case (.some, .none):
            cityLabel.text = "\(location.postalCode ?? "")"
        case (.none, .some):
            cityLabel.text = "\(location.city ?? "")"
        default:
            cityLabel.text = nil
        }
        
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

extension MapViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: R.Images.mapMarker)
        if annotationImage == nil {
            var image = UIImage(named: R.Images.mapMarker)!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0,
                                                               left: 0,
                                                               bottom: 0,
                                                               right: 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: R.Images.mapMarker)
        }
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        locationDetailView.hideFromTop()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        print(mapView.centerCoordinate)
        DataManager().getLocation(coordinate: (mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude)) { location in
            self.location = location
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        DataManager().getLocation(coordinate: (locValue.latitude, locValue.longitude)) { location in
            self.zoomToLocation(coordinate: (latitude: location?.latitude, longitude: location?.longitude), zoom: 13)
            self.location = location
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlertLocation(title: R.String.locationFailed)
    }
}

extension MapViewController: SearchLocationDelegate {
    
    func didSelectLocation(_ location: Location) {
        self.location = location
        zoomToLocation(coordinate: (latitude: location.latitude, longitude: location.longitude))
    }
}

