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
    @IBOutlet fileprivate weak var searchView: UIView!
    
    fileprivate let locationManager = CLLocationManager()
    var location: Location!
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askForLocationPermission()
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func didTouchUpInsideSearchButton(_ sender: UIButton) {
        
    }
    
    @IBAction fileprivate func didTouchUpInsideCurrentButton(_ sender: UIButton) {
        showCurrentUserLocation()
    }
    
    // MARK: - Fileprivate instance methods
    
    fileprivate func showCurrentUserLocation() {
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to Map Search!"
        // Center and zoom to marker.
        mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 12, animated: true)
        // Add marker `hello` to the map.
        mapView.removeAnnotations(mapView.annotations ?? [])
        mapView.addAnnotation(hello)
    }
    
    fileprivate func askForLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

}

extension MapViewController: MGLMapViewDelegate {
    
    // MARK: - Map View Delegate
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        location = Location(latitude: locValue.latitude, longitude: locValue.longitude)
        showCurrentUserLocation()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlertLocation(title: R.String.locationFailed)
    }
}

