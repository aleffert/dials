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

extension String {
    func formatWithParameters(parameters : [String:Any]) -> String {
        let result = self.mutableCopy() as! NSMutableString
        for (key, value) in parameters {
            let range = NSMakeRange(0, result.length)
            let token = "{\(key)}"
            result.replaceOccurrencesOfString(token, withString: "\(value)", options: NSStringCompareOptions(), range: range)
        }
        return result as String
    }
}