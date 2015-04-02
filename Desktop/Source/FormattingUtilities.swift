//
//  FormattingUtilities.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Foundation

func stringFromNumber(value : Float, requireIntegerPart : Bool = false) -> String {
    return stringFromNumber(NSNumber(float: value), requireIntegerPart : requireIntegerPart)
}

func stringFromNumber(value : Double, requireIntegerPart : Bool = false) -> String {
    return stringFromNumber(NSNumber(double: value), requireIntegerPart : requireIntegerPart)
}

func stringFromNumber(value : NSNumber, requireIntegerPart : Bool = false) -> String {
    let formatter = NSNumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.alwaysShowsDecimalSeparator = false
    formatter.minimumIntegerDigits = requireIntegerPart ? 1 : 0
    return formatter.stringFromNumber(value)!
}