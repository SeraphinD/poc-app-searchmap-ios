//
//  LocationTest.swift
//  mapsearchTests
//
//  Created by Seraphin DESUMEUR on 07/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import XCTest
@testable import mapsearch

final class LocationTests: XCTestCase {
    
    private struct LocationTestValues {
        static let userDefaultsSuiteName = "TestDefaults"
        static let testName = "testName"
        static let testNameAlt = "testNameAlt"
        static let testLatitude = 0.0
        static let testLatitudeAlt = 1.0
        static let testLongitude = 0.0
        static let testLongitudeAlt = 1.0
        static let testNumber = "0"
        static let testStreet = "testStreet"
        static let testPostalCode = "00000"
        static let testCity = "testCity"
    }
    
    var testLocation1: Location!
    var testLocation2: Location!
    var testLocation3: Location!
    var testLocation4: Location!
    
    override func setUp() {
        super.setUp()
        testLocation1 = Location(name: LocationTestValues.testName,
                                 latitude: LocationTestValues.testLatitude,
                                 longitude: LocationTestValues.testLongitude,
                                 number: LocationTestValues.testNumber,
                                 street: LocationTestValues.testStreet,
                                 postalCode: LocationTestValues.testPostalCode,
                                 city: LocationTestValues.testCity,
                                 stored: false)
        testLocation2 = Location(name: LocationTestValues.testNameAlt,
                                 latitude: LocationTestValues.testLatitudeAlt,
                                 longitude: LocationTestValues.testLongitudeAlt,
                                 number: nil,
                                 street: LocationTestValues.testStreet,
                                 postalCode: nil,
                                 city: LocationTestValues.testCity,
                                 stored: false)
        testLocation3 = Location(name: LocationTestValues.testNameAlt,
                                 latitude: LocationTestValues.testLatitudeAlt,
                                 longitude: LocationTestValues.testLongitudeAlt,
                                 number: LocationTestValues.testNumber,
                                 street: nil,
                                 postalCode: LocationTestValues.testPostalCode,
                                 city: nil,
                                 stored: false)
        testLocation4 = Location(name: LocationTestValues.testNameAlt,
                                 latitude: LocationTestValues.testLatitudeAlt,
                                 longitude: LocationTestValues.testLongitudeAlt,
                                 number: nil,
                                 street: nil,
                                 postalCode: nil,
                                 city: nil,
                                 stored: false)
    }
    
    func testComputedProperty() {
        XCTAssertTrue(testLocation1.printableStreet == "\(LocationTestValues.testNumber), \(LocationTestValues.testStreet)")
        XCTAssertTrue(testLocation2.printableStreet == LocationTestValues.testStreet)
        XCTAssertNil(testLocation3.printableStreet)
        XCTAssertNil(testLocation4.printableStreet)
        XCTAssertTrue(testLocation1.printableCity == "\(LocationTestValues.testPostalCode), \(LocationTestValues.testCity)")
        XCTAssertTrue(testLocation2.printableCity == LocationTestValues.testCity)
        XCTAssertTrue(testLocation3.printableCity == LocationTestValues.testPostalCode)
        XCTAssertNil(testLocation4.printableCity)
    }
    
    func testEquatable() {
        XCTAssertTrue(testLocation1 == Location(name: LocationTestValues.testName,
                                                latitude: LocationTestValues.testLatitude,
                                                longitude: LocationTestValues.testLongitude,
                                                number: LocationTestValues.testNumber,
                                                street: LocationTestValues.testStreet,
                                                postalCode: LocationTestValues.testPostalCode,
                                                city: LocationTestValues.testCity,
                                                stored: true))
        
        XCTAssertFalse(testLocation1 == testLocation2)
        XCTAssertFalse(testLocation1 == testLocation3)
        XCTAssertFalse(testLocation1 == testLocation4)
        XCTAssertFalse(testLocation2 == testLocation3)
        XCTAssertFalse(testLocation2 == testLocation4)
        XCTAssertFalse(testLocation3 == testLocation4)
    }
    
    func testEncoding() {
        let data = testLocation1.encode()
        let locationDecoded = Location(data: data)
        XCTAssertTrue(testLocation1 == locationDecoded)
        XCTAssertFalse(testLocation2 == locationDecoded)
    }
    
    func testService() {
        let service = LocationService()
        service.getLocation(coordinate: (0.0, 0.0)) { location in
            XCTAssertNotNil(location)
        }
        service.searchLocations("Paris") { locations in
            XCTAssertNotNil(locations)
            XCTAssertTrue(!(locations!.isEmpty))
        }
    }
    
    func testStorage() {
        
        @discardableResult
        func clearUserDefaults() -> Bool {
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
                return true
            }
            return false
        }
        guard clearUserDefaults() else {
            XCTFail()
            return
        }
        
        let storage = LocationStorage()
        
        XCTAssertNil(storage.getStoredLocations())
        
        storage.storeLocation(testLocation1)
        XCTAssertTrue(storage.getStoredLocations()?.count == 1)
        XCTAssertTrue((storage.getStoredLocations()?.contains(testLocation1))!)
        
        storage.storeLocation(testLocation1)
        XCTAssertTrue(storage.getStoredLocations()?.count == 1)
        XCTAssertTrue((storage.getStoredLocations()?.contains(testLocation1))!)
        
        storage.storeLocation(testLocation2)
        storage.storeLocation(testLocation3)
        XCTAssertTrue(storage.getStoredLocations()?.count == 2)
        XCTAssertTrue((storage.getStoredLocations()?.contains(testLocation2))!)
        XCTAssertTrue((storage.getStoredLocations()?.contains(testLocation3))!)
        
        storage.storeLocation(testLocation2)
        XCTAssertTrue(storage.getStoredLocations()?.first == testLocation2)
        
        storage.getStoredLocations()?.forEach {
            XCTAssertTrue($0.stored)
        }
        
        clearUserDefaults()
    }
    
    func testManager() {
        DataManager.shared.searchLocations(query: "") { locations in
            XCTAssertNil(locations)
        }
    }
    
}


