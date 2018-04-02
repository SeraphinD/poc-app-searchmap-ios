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
    init(geocodedPlacemark: GeocodedPlacemark) {
        name = geocodedPlacemark.name
        latitude = geocodedPlacemark.location?.coordinate.latitude
        longitude = geocodedPlacemark.location?.coordinate.longitude
        number = geocodedPlacemark.addressDictionary?["subThoroughfare"] as? String
        city = geocodedPlacemark.addressDictionary?[MBPostalAddressCityKey] as? String
        street = geocodedPlacemark.addressDictionary?[MBPostalAddressStreetKey] as? String
        postalCode = geocodedPlacemark.addressDictionary?[MBPostalAddressPostalCodeKey] as? String
    }
}
