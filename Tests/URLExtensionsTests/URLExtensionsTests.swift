//
//  URLExtensionsTests.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import XCTest
@testable import URLExtensions

final class URLExtensionsTests: XCTestCase {
    func testURLComponentsAddToPath() throws {
        var components = try XCTUnwrap(URLComponents(string: "https://example.com"))
        components.append(path: "hello")
        components.append(path: "world/")
        components.append(path: "test/one/")
        let url = try XCTUnwrap(components.string)
        XCTAssertEqual(url, "https://example.com/hello/world/test/one")
    }
}
