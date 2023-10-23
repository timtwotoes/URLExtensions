//
//  URLExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

extension URL {
    public enum Specfication {
        case RFC3986
    }
    
    /// Creates an URL instance from the provided string according to the RFC3986 specification.
    /// - Parameters:
    ///   - string: An URL location
    ///   - specification: Specification used for validation
    public init?(string: String, specification: Specfication = .RFC3986) {
        switch specification {
        case .RFC3986:
            guard let components = URLComponents(string: string), let url = components.url else {
                return nil
            }
                
            self = url
        }
    }
}
