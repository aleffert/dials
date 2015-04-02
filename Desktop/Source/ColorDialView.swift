//
//  ColorDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSColorDescription : LiveDialViewGenerating {
    func generate() -> LiveDialView {
        return LiveDialView.freshViewFromNib("ColorDialView")
    }
}

extension DLSColorDescription : CodeGenerating {
    func objcCodeForValue(value: NSCoding?) -> String {
        if let c = value as? NSColor {
            let red = c.redComponent
            let green = c.greenComponent
            let blue = c.blueComponent
            let alpha = c.alphaComponent
            return "[[UIColor alloc] initWithRed:\(red) green:\(green) blue:\(blue) alpha:\(alpha)]"
        }
        else {
            return "nil"
        }
    }
    
    func swiftCodeForValue(value: NSCoding?) -> String {
        if let c = value as? NSColor {
            let red = c.redComponent
            let green = c.greenComponent
            let blue = c.blueComponent
            let alpha = c.alphaComponent
            return "UIColor(red:\(red) green:\(green) blue:\(blue) alpha:\(alpha))"
        }
        else {
            return "nil"
        }
    }
}

class ColorDialView : LiveDialView {
    
    @IBOutlet private var well : NSColorWell?
    @IBOutlet private var name : NSTextField?
    
    @IBAction func colorChanged(well : NSColorWell) {
        dial.map {
            self.delegate?.dialView(self, changedDial: $0, toValue: well.color)
        }
    }
    
    override var dial : DLSLiveDial? {
        didSet {
            let value = dial?.value() as? NSColor
            well?.color = value ?? NSColor.clearColor()
            
            name?.stringValue = dial!.displayName
        }
    }
}