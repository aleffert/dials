//
//  ColorEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSColorDescription : EditorViewGenerating {
    func generate() -> EditorView {
        return EditorView.freshViewFromNib("ColorEditorView")
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

class ColorEditorView : EditorView {
    
    @IBOutlet private var well : NSColorWell?
    @IBOutlet private var name : NSTextField?
    
    @IBAction func colorChanged(well : NSColorWell) {
        info.map {
            self.delegate?.editorView(self, changedInfo: $0, toValue: well.color)
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            let color = info?.value as? NSColor
            well?.color = color ?? NSColor.clearColor()
            
            name?.stringValue = info?.name ?? "Color"
        }
    }
}