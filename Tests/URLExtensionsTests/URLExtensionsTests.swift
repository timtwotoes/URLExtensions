//
//  URLExtensionsTests.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import XCTest
@testable import URLExtensions

final class URLExtensionsTests: XCTestCase {
    func testURLComponentsAppendPath() throws {
        var components = try XCTUnwrap(URLComponents(string: "https://example.com"))
        components.append(path: "hello")
        components.append(path: "world/")
        components.append(path: "test/one/")
        let string = try XCTUnwrap(components.string)
        XCTAssertEqual(string, "https://example.com/hello/world/test/one")
    }
    
    func testURLComponentsAddQuery() throws {
        var components = try XCTUnwrap(URLComponents(string: "https://example.com"))
        
        components.addQuery("isMutable")
        components.addQuery("title", value: "example")
        
        let string = try XCTUnwrap(components.string)
        XCTAssertEqual(string, "https://example.com?isMutable&title=example")
    }
    
    func testURLClosureWithString() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com") { components in
            components.append(path: "test")
        })
        
        XCTAssertEqual(url.absoluteString, "https://example.com/test")
    }
    
    func testURLClosureWithBaseURL() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://example.com"))
        let url = try XCTUnwrap(URL(baseURL: baseURL) { components in
            components.append(path: "test")
        })
        
        XCTAssertEqual(url.absoluteString, "https://example.com/test")
    }
    
    func testURLModifyClosure() throws {
        var url = try XCTUnwrap(URL(string: "https://example.com"))
        
        url.modify { components in
            components.append(path: "test")
        }
                
        XCTAssertEqual(url.absoluteString, "https://example.com/test")
    }
    
    func testURLModifiedClosure() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        
        let modifiedURL = url.modified { components in
            components.scheme = "http"
            components.append(path: "test")
        }
        
        XCTAssertEqual(modifiedURL?.absoluteString, "http://example.com/test")
    }
}
