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
        
        var error : NSError?
        let matcher = NSRegularExpression(pattern: pattern,
            options: options,
            error: &error)
        if let e = error {
            return Failure(e.localizedDescription)
        }
        return Success(matcher!)
    }
}