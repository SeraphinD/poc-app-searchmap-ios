//
//  LocationStorage.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 02/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class LocationStorage {
    
    private let locationsStorageLimit = 2
    
    private struct StorageKey {
        static let locations = "locations"
    }
    
    private let userDefaults = UserDefaults.standard
    
    func storeLocation(_ location: Location) {
        var locations = getStoredLocations() ?? []
        locations = locations.filter { $0 != location }
        if locations.count >= locationsStorageLimit { locations.removeLast() }
        locations.insert(location, at: 0)
        userDefaults.set(locations.map { $0.encode() }, forKey: StorageKey.locations)
    }
    
    func getStoredLocations() -> [Location]? {
        guard let locationsData = userDefaults.object(forKey: StorageKey.locations) as? [Data] else { return nil }
        var locations = locationsData.compactMap { return Location(data: $0) }
        for i in 0..<locations.count { locations[i].stored = true }
        return locations
    }
}
