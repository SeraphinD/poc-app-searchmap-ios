//
//  DataManager.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class DataManager {
    
    func searchLocations(query: String, completion:@escaping ([Location]?) -> Void) {
        
        guard !query.isEmpty else {
            completion(nil)
            return
        }
        
        LocationService().searchLocations(query) { locations in
            completion(locations)
        }
    }
    
    func getLocation(coordinate: (latitude: Double, longitude: Double),
                     completion: @escaping (Location?) -> Void) {
        
        LocationService().getLocation(coordinate: coordinate) { location in
            completion(location)
        }
    }
    
    func storeLocation(_ location: Location) {
        LocationStorage().storeLocation(location)
    }
    
    func getStoredLocations() -> [Location]? {
        let locations = LocationStorage().getStoredLocations()
        return locations
    }
}
