//
//  LocationService.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation
import MapboxGeocoder

final class LocationService {
    
    func searchLocations(_ query: String, completion: @escaping ([Location]?) -> Void) {
        
        let options = ForwardGeocodeOptions(query: query)
        
        options.allowedScopes = [.address, .pointOfInterest]
        
        Geocoder.shared.geocode(options) { (placemarks, attribution, error) in
            let locations = placemarks?.compactMap { Location(geocodedPlacemark: $0) }
            completion(locations)
        }
    }
    
    func getLocation(coordinate: (latitude: Double, longitude: Double),
                     completion: @escaping (Location?) -> Void) {
        
        let options = ReverseGeocodeOptions(coordinate:
            CLLocationCoordinate2D(latitude: coordinate.latitude,
                                   longitude: coordinate.longitude))
        
        options.allowedScopes = [.address, .pointOfInterest]
        
        Geocoder.shared.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            completion(Location(geocodedPlacemark: placemark))
        }
    }
}
