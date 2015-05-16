//
//  CodeGenerating.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/23/15.
//
//

import Foundation

/// Implement this protocol to support changes back to code
protocol CodeGenerating {
    func codeForValue(value : NSCoding?, language : Language) -> String
}