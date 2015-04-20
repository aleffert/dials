//
//  BackgroundColorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

@IBDesignable class BackgroundColorView: NSView {
    
    @IBInspectable var backgroundColor : NSColor?
    
    override var opaque : Bool {
        return false
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let color = backgroundColor ?? NSColor.clearColor()
        color.setFill()
        NSRectFill(dirtyRect)
    }
    
}
