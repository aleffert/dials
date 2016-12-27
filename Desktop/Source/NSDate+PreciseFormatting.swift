//
//  NSDate+PreciseFormatting.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/10/15.
//
//

import Foundation

private let formatter = { () -> DateFormatter in 
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
    return formatter
}()

extension Date {
    var preciseDateString : String {
        return formatter.string(from: self)
    }
}
