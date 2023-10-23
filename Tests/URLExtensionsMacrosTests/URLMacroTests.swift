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
            URL(string: "https://www.example.com/", specification: .RFC3986)!
            """#,
            macros: testMacros
        )
    }
    
    func testURLStringLiteralError() {
        assertMacroExpansion(
            #"""
            #URL("https://www.example.com/\(Int.random())")
            """#,
            expandedSource: #"""
            #URL("https://www.example.com/\(Int.random())")
            """#,
            diagnostics: [
                DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    
    func testURLStringMalformedError() {
        assertMacroExpansion(
            #"""
            #URL("https://www.example test.com/")
            """#,
            expandedSource: #"""
            #URL("https://www.example test.com/")
            """#,
            diagnostics: [
                DiagnosticSpec(message: "The input URL is malformed: \"https://www.example test.com/\"", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
