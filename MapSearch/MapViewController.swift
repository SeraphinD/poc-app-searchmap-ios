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
    
    fileprivate let locationManager = CLLocationManager()
    var location: Location? {
        didSet {
            showLocation(location)
        }
    }
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocation(location)
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func didTouchUpInsideSearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: R.Segue.showSearchBar, sender: self)
    }
    
    @IBAction fileprivate func didTouchUpInsideCurrentButton(_ sender: UIButton) {
        askForLocationPermission()
    }
    
    // MARK: - Fileprivate instance methods
    
    fileprivate func showLocation(_ location: Location?) {
        guard let location = location else {
            askForLocationPermission()
            return
        }
        let marker = MGLPointAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: location.latitude!,
                                                   longitude: location.longitude!)
        mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude!,
                                                 longitude: location.longitude!),
                          zoomLevel: 13, animated: true)
        mapView.removeAnnotations(mapView.annotations ?? [])
        mapView.addAnnotation(marker)
    }
    
    fileprivate func askForLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
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
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: R.Images.mapMarker)
        if annotationImage == nil {
            var image = UIImage(named: R.Images.mapMarker)!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0,
                                                               left: 0,
                                                               bottom: image.size.height/2,
                                                               right: 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: R.Images.mapMarker)
        }
        return annotationImage
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        location = Location(name: nil,
                            latitude: locValue.latitude,
                            longitude: locValue.longitude,
                            number: nil,
                            street: nil,
                            postalCode: nil,
                            city: nil)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentAlertLocation(title: R.String.locationFailed)
    }
}

extension MapViewController: SearchLocationDelegate {
    
    func didSelectLocation(_ location: Location) {
        self.location = location
    }
}

