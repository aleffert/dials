//
//  DLSOptionEditing.swift
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

// Simply implement this protocol to allow your type to be represented as a popup option list
public protocol DLSOptionEditing {
    static var dls_optionItems : [(String, Self)] { get }
    static func dls_wrapOptionValue(value : Self) -> AnyObject
    static func dls_unwrapOptionValue(value : AnyObject) -> Self
}

extension NSTextAlignment : DLSOptionEditing {
    public static var dls_optionItems : [(String, NSTextAlignment)] {
        return [
            ("Left", .Left),
            ("Center", .Center),
            ("Right", .Right),
            ("Natural", .Natural),
        ]
    }
    
    public static func dls_wrapOptionValue(value: NSTextAlignment) -> AnyObject {
        return NSNumber(integer: value.rawValue)
    }
    
    public static func dls_unwrapOptionValue(value: AnyObject) -> NSTextAlignment {
        return NSTextAlignment(rawValue: (value as? NSNumber)?.integerValue ?? 0) ?? .Natural
    }
}
