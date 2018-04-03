//
//  Location.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation
import MapboxGeocoder

struct Location {
    let name: String?
    let latitude: Double?
    let longitude: Double?
    let number: String?
    let street: String?
    let postalCode: String?
    let city: String?
}

extension Location {
    
    private struct StorageKey {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let number = "number"
        static let street = "street"
        static let postalCode = "postalCode"
        static let city = "city"
    }
    
    init(geocodedPlacemark: GeocodedPlacemark) {
        name = geocodedPlacemark.name
        latitude = geocodedPlacemark.location?.coordinate.latitude
        longitude = geocodedPlacemark.location?.coordinate.longitude
        number = geocodedPlacemark.addressDictionary?["subThoroughfare"] as? String
        city = geocodedPlacemark.addressDictionary?[MBPostalAddressCityKey] as? String
        street = geocodedPlacemark.addressDictionary?[MBPostalAddressStreetKey] as? String
        postalCode = geocodedPlacemark.addressDictionary?[MBPostalAddressPostalCodeKey] as? String
    }
    
    func encode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(name, forKey: StorageKey.name)
        archiver.encode(latitude, forKey: StorageKey.latitude)
        archiver.encode(longitude, forKey: StorageKey.longitude)
        archiver.encode(number, forKey: StorageKey.number)
        archiver.encode(street, forKey: StorageKey.street)
        archiver.encode(postalCode, forKey: StorageKey.postalCode)
        archiver.encode(city, forKey: StorageKey.city)
        archiver.finishEncoding()
        return data as Data
    }
        
    init?(data: Data) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        defer {
            unarchiver.finishDecoding()
        }
        let name = unarchiver.decodeObject(forKey: StorageKey.name) as? String
        let latitude = unarchiver.decodeObject(forKey: StorageKey.latitude) as? Double
        let longitude = unarchiver.decodeObject(forKey: StorageKey.longitude) as? Double
        let number = unarchiver.decodeObject(forKey: StorageKey.number) as? String
        let street = unarchiver.decodeObject(forKey: StorageKey.street) as? String
        let postalCode = unarchiver.decodeObject(forKey: StorageKey.postalCode) as? String
        let city = unarchiver.decodeObject(forKey: StorageKey.city) as? String
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.number = number
        self.city = city
        self.postalCode = postalCode
    }
}
