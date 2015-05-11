//
//  NSDate+PreciseFormatting.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/10/15.
//
//

import Foundation

extension NSDate {
    var preciseDateString : String {
        var token = 0
        var formatter : NSDateFormatter!
        dispatch_once(&token) {
            formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        }
        
        return formatter.stringFromDate(self)
    }
}