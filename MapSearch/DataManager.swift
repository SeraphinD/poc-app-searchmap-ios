//
//  DataManager.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class DataManager {
    
    private let locationService: LocationService
    private let locationStorage: LocationStorage
    
    init() {
        locationService = LocationService()
        locationStorage = LocationStorage()
    }
    
    func searchLocations(query: String, completion:@escaping ([Location]?) -> Void) {
        
        guard !query.isEmpty else {
            completion(nil)
            return
        }
        
        locationService.searchLocations(query) { locations in
            completion(locations)
        }
    }
    
    func getLocation(coordinate: (latitude: Double, longitude: Double),
                     completion: @escaping (Location?) -> Void) {
        
        locationService.getLocation(coordinate: coordinate) { location in
            completion(location)
        }
    }
    
    func storeLocation(_ location: Location) {
        locationStorage.storeLocation(location)
    }
    
    func getStoredLocations() -> [Location]? {
        return locationStorage.getStoredLocations()
    }
}
