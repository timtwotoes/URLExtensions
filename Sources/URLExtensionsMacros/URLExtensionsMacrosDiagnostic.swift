//
//  URLExtensionsMacrosDiagnostic.swift
//
//
//  Created by Tim Wolff on 24/10/2023.
//

import Foundation
import SwiftDiagnostics

enum URLExtensionsMacrosDiagnostic: String, DiagnosticMessage {
    case malformedURL
    
    var severity: DiagnosticSeverity {
        switch self {
        case .malformedURL: .error
        }
    }
    
    var message: String {
        switch self {
        case .malformedURL: "URL is malformed according to the RFC3986 specification"
        }
    }
    
    var diagnosticID: MessageID {
        switch self {
        case .malformedURL: MessageID(domain: "URLExtensionsMacrosDiagnostic", id: "#URL-0001")
        }
        
    }
}
