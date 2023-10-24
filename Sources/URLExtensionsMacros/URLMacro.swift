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
import SwiftDiagnostics
import Foundation

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let urlString = extract(argument: node.argumentList)
        /// 4. Validate whether the String literal matches a valid URL structure.
        guard let _ = URL(string: urlString, specification: .RFC3986) else {
            let diagnostic = Diagnostic(node: node.argumentList.first!, message: URLExtensionsMacrosDiagnostic.malformedURL)
            context.diagnose(diagnostic)
            return ""
        }

        return "URL(string: \"\(raw: urlString)\", specification: .RFC3986)!"
    }
    
    private static func extract(argument: LabeledExprListSyntax) -> String {
        if case .stringSegment(let literalSegment) = argument.first!.expression.as(StringLiteralExprSyntax.self)!.segments.first! {
            return literalSegment.content.text
        }
        // This will never happen. This macro will never be called in the first place, if no static string was passed to macro.
        fatalError("Expected a static literal string from #URL but none found!")
    }
}

@main
struct URLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
    ]
}
