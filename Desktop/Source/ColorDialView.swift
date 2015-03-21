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