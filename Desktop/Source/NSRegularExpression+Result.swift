//
//  NSRegularExpression+Result.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/23/15.
//
//

import Foundation

extension NSRegularExpression {
    class func compile(pattern : String, options : NSRegularExpressionOptions = NSRegularExpressionOptions()) -> Result<NSRegularExpression> {
        
        do {
            let matcher = try NSRegularExpression(pattern: pattern,
                        options: options)
            return Success(matcher)
        } catch let e as NSError {
            return Failure(e.localizedDescription)
        }
    }
}