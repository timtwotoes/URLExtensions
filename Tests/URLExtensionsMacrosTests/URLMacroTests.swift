//
//  URLMacroTests.swift
//  
//
//  Created by Tim Wolff on 23/10/2023.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(URLExtensionsMacros)
import URLExtensionsMacros

let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self
]
#endif

final class URLMacroTests: XCTestCase {
    func testURLStringLiteral() {
        assertMacroExpansion(
            #"""
            #URL("https://www.example.com/")
            """#,
            expandedSource: #"""
            URL(string: "https://www.example.com/", specification: .rfc3986)!
            """#,
            macros: testMacros
        )
    }
    
    func testURLStringMalformedError() {
        assertMacroExpansion(
            #"""
            #URL("https://www.example test.com/")
            """#,
            expandedSource: #"""
            """#,
            diagnostics: [
                DiagnosticSpec(message: "URL is malformed according to the rfc3986 specification", line: 1, column: 6)
            ],
            macros: testMacros
        )
    }
}
