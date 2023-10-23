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
