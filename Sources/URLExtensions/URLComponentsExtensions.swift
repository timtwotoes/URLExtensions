//
//  URLComponentsExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

extension URLComponents {
    /// Creates a new query item with the name and value you specify.
    ///
    /// Value is optional and creates a stand-alone query, if no value is specified.
    ///
    /// ```swift
    /// var components = URLComponents(string: "https://example.com")!
    /// components.addQuery("showExamples")
    /// ```
    ///
    /// Produces the URL string "https://example.com?showExamples".
    ///
    /// - Parameters:
    ///   - name: The name of the query item
    ///   - value: The value for the query item
    ///
    /// - note: URLComponents automatically percent encode the query.
    mutating public func addQuery(_ name: String, value: String? = nil) {
        if queryItems == nil {
            queryItems = [URLQueryItem]()
        }
        
        queryItems?.append(URLQueryItem(name: name, value: value))
    }
    
    
    /// Append one or more path components.
    /// - Parameter path: One or more path strings separated with a slash
    /// - note: URLComponents automatically percent encode the path.
    mutating public func append(path: String) {
        guard path.isEmpty == false else {
            return
        }
        
        let trimmedPath = "/" + path.trimmingCharacters(in: .pathSeparator)
        self.path.append(trimmedPath)
    }
}
