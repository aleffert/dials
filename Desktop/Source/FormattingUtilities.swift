//
//  FormattingUtilities.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Foundation

func stringFromNumber(_ value : Float, requireIntegerPart : Bool = false) -> String {
    return stringFromNumber(NSNumber(value: value as Float), requireIntegerPart : requireIntegerPart)
}

func stringFromNumber(_ value : CGFloat, requireIntegerPart : Bool = false) -> String {
    return stringFromNumber(NSNumber(value: Double(value)), requireIntegerPart : requireIntegerPart)
}

func stringFromNumber(_ value : Double, requireIntegerPart : Bool = false) -> String {
    return stringFromNumber(NSNumber(value: value as Double), requireIntegerPart : requireIntegerPart)
}

func stringFromNumber(_ value : NSNumber, requireIntegerPart : Bool = false) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.alwaysShowsDecimalSeparator = false
    formatter.minimumIntegerDigits = requireIntegerPart ? 1 : 0
    return formatter.string(from: value)!
}

extension String {
    func formatWithParameters(_ parameters : [String:Any]) -> String {
        let result = self.mutableCopy() as! NSMutableString
        for (key, value) in parameters {
            let range = NSMakeRange(0, result.length)
            let token = "{\(key)}"
            result.replaceOccurrences(of: token, with: "\(value)", options: NSString.CompareOptions(), range: range)
        }
        return result as String
    }
}
