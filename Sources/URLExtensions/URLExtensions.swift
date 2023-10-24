//
//  URLExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

/// A macro that produces an unwrapped URL in case of a valid input URL.
/// For example,
///
///     #URL("https://www.example.com")
///
/// produces an unwrapped `URL` if the URL is valid. Otherwise, it emits a compile-time error.
@freestanding(expression)
public macro URL(_ stringLiteral: StaticString) -> URL = #externalMacro(module: "URLExtensionsMacros", type: "URLMacro")

extension URL {
    public init?(string: String, _ updateComponents: (_ components: inout URLComponents) -> ()) {
        guard var components = URLComponents(string: "\(string)") else {
            return nil
        }
        
        updateComponents(&components)
        
        guard let url = components.url else {
            return nil
        }
        
        self = url
    }
    
    public init?(baseURL: URL, _ updateComponents: (_ components: inout URLComponents) -> ()) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        updateComponents(&components)
        
        guard let url = components.url else {
            return nil
        }
        
        self = url
    }
    
    @discardableResult
    mutating public func modify(_ updateComponents: (_ components: inout URLComponents) -> ()) -> Bool {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        updateComponents(&components)
        
        guard let url = components.url else {
            return false
        }
        
        self = url
        return true
    }
    
    public func modified(_ updateComponents: (_ components: inout URLComponents) -> ()) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        updateComponents(&components)
        
        return components.url        
    }
}
