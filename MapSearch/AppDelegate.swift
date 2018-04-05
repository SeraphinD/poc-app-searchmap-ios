//
//  AppDelegate.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

let dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let dataManager = DataManager()
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

