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
    
    override var isOpaque : Bool {
        return false
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let color = backgroundColor ?? NSColor.clear
        color.setFill()
        NSRectFill(dirtyRect)
    }
    
    override var isFlipped : Bool {
        return true
    }
    
}
