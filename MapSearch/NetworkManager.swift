//
//  NetworkManager.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static var cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    static var timeoutInterval: TimeInterval = 10.0

    #if DEBUG
    static var showDebugLog = true
    #else
    static var showDebugLog = false
    #endif
}

