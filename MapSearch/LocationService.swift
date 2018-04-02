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
    
    private let geocoder = Geocoder.shared
    
    func searchLocations(_ query: String, completion: @escaping ([Location]?) -> Void) {
        let options = ForwardGeocodeOptions(query: query)
        
        options.allowedScopes = [.address, .pointOfInterest]
        
        geocoder.geocode(options) { (placemarks, attribution, error) in
            let locations = placemarks?.compactMap { Location(geocodedPlacemark: $0) }
            completion(locations)
        }
    }
}
