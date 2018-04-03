//
//  LocationStorage.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 02/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class LocationStorage {
    
    private struct StorageKey {
        static let locations = "locations"
    }
    
    private let userDefaults = UserDefaults.standard
    
    func storeLocation(_ location: Location) {
        var locations = getStoredLocations() ?? []
        if locations.count > 2 { locations.removeFirst() }
        locations.append(location)
        userDefaults.set(locations.map { $0.encode() }, forKey: StorageKey.locations)
    }
    
    func getStoredLocations() -> [Location]? {
        guard let locationsData = userDefaults.object(forKey: StorageKey.locations) as? [Data] else { return nil }
        return locationsData.compactMap { return Location(data: $0) }
    }
}
