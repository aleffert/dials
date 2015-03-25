//
//  FormattingUtilities.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Foundation

func stringFromNumber(value : Float) -> String {
    return stringFromNumber(NSNumber(float: value))
}

func stringFromNumber(value : Double) -> String {
    return stringFromNumber(NSNumber(double: value))
}

func stringFromNumber(value : NSNumber) -> String {
    let formatter = NSNumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.alwaysShowsDecimalSeparator = false
    return formatter.stringFromNumber(value)!
}