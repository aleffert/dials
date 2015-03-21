//
//  LiveDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

protocol LiveDialViewDelegate : class {
    func dialView(view : LiveDialView, changedDial dial : DLSLiveDial, toValue value: NSCoding?)
}

class LiveDialView : NSView {
    weak var delegate : LiveDialViewDelegate?
    var dial : DLSLiveDial?
}

@objc protocol LiveDialViewGenerating : class {
    func generate() -> LiveDialView
}