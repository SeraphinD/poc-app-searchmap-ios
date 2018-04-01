//
//  Router.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

final class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping ServiceCompletionHandler) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                self.printResponse(data)
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: NetworkManager.cachePolicy, timeoutInterval: NetworkManager.timeoutInterval)
        
        request.httpMethod = route.method.rawValue
        
        do {
            switch route.encoding {
            case .bodyEncoding?:
                try self.configureParameters(bodyParameters: route.parameters, request: &request)
            case .URLEncoding?:
                try self.configureParameters(urlParameters: route.parameters, request: &request)
            default:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            configureHeaders(route.headers, request: &request)
            
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: HTTPParameters? = nil, urlParameters: HTTPParameters? = nil, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder().encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func configureHeaders(_ headers: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func printResponse(_ data: Data?) {
        if NetworkManager.showDebugLog,
            let data = data,
            let responseData = String(data: data, encoding: .utf8) {
            print(responseData)
        }
    }
}
