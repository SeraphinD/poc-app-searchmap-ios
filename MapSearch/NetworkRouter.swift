//
//  NetworkRouter.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

typealias ServiceCompletionHandler = (_ data: Data?,
    _ response: URLResponse?,
    _ error: Error?)
    -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping ServiceCompletionHandler)
    func cancel()
}
