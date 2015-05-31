//
//  CodeGenerating.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/23/15.
//
//

import Foundation

/// Implement this protocol as an extension on a DLSEditor implementation to
/// support sending changes back to code for that type
protocol CodeGenerating {
    func codeForValue(value : NSCoding?, language : Language) -> String
}