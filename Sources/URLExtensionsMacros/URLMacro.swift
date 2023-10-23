//
//  URLMacro.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

enum URLMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case malformedURL(urlString: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case .malformedURL(let urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}

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


public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            /// 1. Grab the first (and only) Macro argument.
            let argument = node.argumentList.first?.expression,
            /// 2. Ensure the argument contains of a single String literal segment.
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            /// 3. Grab the actual String literal segment.
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw URLMacroError.requiresStaticStringLiteral
        }

        /// 4. Validate whether the String literal matches a valid URL structure.
        guard let _ = URL(string: literalSegment.content.text, specification: .RFC3986) else {
            throw URLMacroError.malformedURL(urlString: "\(argument)")
        }

        return "URL(string: \(argument), specification: .RFC3986)!"
    }
}

@main
struct URLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
    ]
}
