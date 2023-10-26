//
//  URLExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

/// Produces an unwrapped URL when string is correctly formed. A malformed URL triggers a
/// compilation error.
///
@freestanding(expression)
public macro URL(_ stringLiteral: StaticString) -> URL = #externalMacro(module: "URLExtensionsMacros", type: "URLMacro")

extension URL {
    /// Initialize an URL using URLComponents.
    ///
    /// URLComponents uses the rfc3986 specification. URL uses  older specifications.
    /// Example of usage:
    ///
    /// ```swift
    /// let url = URL(string: "http://example.com") { components in
    ///     components.scheme = "https"
    ///     components.add(path: "hello world")
    /// }!
    /// ```
    /// Produces an URL with the string "https://example.com/hello%20world"
    ///
    /// - Parameters:
    ///   - string: An URL string
    ///   - componentsHandler: A closure for modifying the URL using URLComponents.
    public init?(string: String, _ componentsHandler: (_ components: inout URLComponents) -> ()) {
        guard var components = URLComponents(string: "\(string)") else {
            return nil
        }
        
        componentsHandler(&components)
        
        guard let url = components.url else {
            return nil
        }
        
        self = url
    }

    /// Initialize an URL using URLComponents with another URL as a base.
    ///
    /// URLComponents uses the rfc3986 specification. URL uses older specifications.
    /// Example of usage:
    ///
    /// ```swift
    /// let siteURL = URL(string: "https://example.com", specification: .rfc3986)
    /// let url = URL(baseURL: siteURL) { components in
    ///     components.host = "api.example.com"
    /// }!
    /// ```
    /// Produces an URL with the string "https://api.example.com"
    ///
    /// - Parameters:
    ///   - baseURL: An URL that serves as the base for modification
    ///   - componentsHandler: A closure for modifying the URL using URLComponents.
    public init?(baseURL: URL, _ componentsHandler: (_ components: inout URLComponents) -> ()) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        componentsHandler(&components)
        
        guard let url = components.url else {
            return nil
        }
        
        self = url
    }
    
    @discardableResult
    /// Modify an URL in place.
    ///
    /// URLComponents uses the RFC3986 specification. URL uses older specifications.
    /// Example of usage:
    ///
    /// ```swift
    /// var siteURL = URL(string: "https://example.com", specification: .RFC3986)
    /// siteURL.modify { components in
    ///     components.host = "api.example.com"
    /// }!
    /// ```
    /// Produces an URL with the string "https://api.example.com"
    ///
    /// - Parameter componentsHandler: Closure for modifying URLComponents
    /// - Returns: True if URL was modified. URL is only modified if it is well formed.
    mutating public func modify(_ componentsHandler: (_ components: inout URLComponents) -> ()) -> Bool {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        componentsHandler(&components)
        
        guard let url = components.url else {
            return false
        }
        
        self = url
        return true
    }
    
    /// Creates a new modified URL from the URL itself
    ///
    /// URLComponents uses the rfc3986 specification. URL uses older specifications.
    /// Example of usage:
    ///
    /// ```swift
    /// let siteURL = URL(string: "https://example.com", specification: .rfc3986)
    /// let newURL = siteURL.modify { components in
    ///     components.host = "api.example.com"
    /// }!
    /// ```
    /// Produces an URL with the string "https://api.example.com"
    /// 
    /// - Parameter componentsHandler: Closure for modifying URLComponents
    /// - Returns: A new modified URL
    public func modified(_ componentsHandler: (_ components: inout URLComponents) -> ()) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        componentsHandler(&components)
        
        return components.url        
    }
}
