//
//  CharacterSetExtensions.swift
//
//
//  Created by Tim Wolff on 23/10/2023.
//

import Foundation

extension CharacterSet {
    internal static var pathSeparator: CharacterSet {
        return CharacterSet(charactersIn: "/")
    }
}
