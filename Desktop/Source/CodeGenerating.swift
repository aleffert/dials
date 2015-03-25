//
//  CodeGenerating.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/23/15.
//
//

import Foundation

@objc protocol CodeGenerating {
    func codeForValue(value : NSCoding?) -> String
}