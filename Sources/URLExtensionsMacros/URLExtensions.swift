//
//  URLExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

extension URL {
    /// URL specifications
    public enum Specfication {
        /// The [RFC3986 specification](https://www.ietf.org/rfc/rfc3986.txt)
        case RFC3986
    }
    
    /// Creates an URL instance from the provided string according to the RFC3986 specification.
    ///
    /// URLComponents uses the RFC3986 specification. URL uses  older specifications.
    /// Example of usage:
    ///
    /// ```swift
    /// let url = URL(string: "https://example.com", specification: .RFC3986)!
    /// ```
    /// Produces an URL string "https://example.com"
    ///
    /// - Parameters:
    ///   - string: An URL location
    ///   - specification: Specification used for validation
    public init?(string: String, specification: Specfication) {
        switch specification {
        case .RFC3986:
            guard let components = URLComponents(string: string), let url = components.url else {
                return nil
            }
                
            self = url
        }
    }
}
