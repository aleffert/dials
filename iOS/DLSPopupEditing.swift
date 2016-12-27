//
//  DLSOptionEditing.swift
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

// Simply implement this protocol to allow your type to be represented as a popup option list

public protocol DLSValueWrapping {
    static func dls_wrapValue(_ value : Self) -> AnyObject
    static func dls_unwrapValue(_ value : AnyObject) -> Self
}

public protocol DLSPopupEditing : DLSValueWrapping {
    static var dls_popupItems : [(String, Self)] { get }
}

// TODO: Add way more types here
extension NSTextAlignment : DLSPopupEditing {
    public static var dls_popupItems : [(String, NSTextAlignment)] {
        return [
            ("Left", .left),
            ("Center", .center),
            ("Right", .right),
            ("Natural", .natural),
        ]
    }
    
    public static func dls_wrapValue(_ value: NSTextAlignment) -> AnyObject {
        return value.rawValue as NSNumber
    }
    
    public static func dls_unwrapValue(_ value: AnyObject) -> NSTextAlignment {
        return NSTextAlignment(rawValue: (value as? NSNumber)?.intValue ?? 0) ?? .natural
    }
}
