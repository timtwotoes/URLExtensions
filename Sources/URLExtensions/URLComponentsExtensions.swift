//
//  URLComponentsExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

extension URLComponents {
    mutating public func addQueryItem(_ name: String, value: String? = nil) {
        if queryItems == nil {
            queryItems = [URLQueryItem]()
        }
        
        queryItems?.append(URLQueryItem(name: name, value: value))
    }
    
    mutating public func append(path: String) {
        guard path.isEmpty == false else {
            return
        }
        
        let trimmedPath = "/" + path.trimmingCharacters(in: .pathSeparator)
        self.path.append(trimmedPath)
    }
}
