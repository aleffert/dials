//
//  ColorEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSColorEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return EditorView.freshViewFromNib("ColorEditorView")
    }
}

extension DLSColorEditor : CodeGenerating {
    
    public func codeForValue(value: NSCoding?, language: Language) -> String {
        if let c = value as? NSColor {
            let red = stringFromNumber(c.redComponent, requireIntegerPart:true)
            let green = stringFromNumber(c.greenComponent, requireIntegerPart:true)
            let blue = stringFromNumber(c.blueComponent, requireIntegerPart:true)
            let alpha = stringFromNumber(c.alphaComponent, requireIntegerPart:true)
            switch language {
            case .ObjC:
                return "[[UIColor alloc] initWithRed:\(red) green:\(green) blue:\(blue) alpha:\(alpha)]"
            case .Swift:
                return "UIColor(red:\(red), green:\(green), blue:\(blue), alpha:\(alpha))"
            }
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
        self.delegate?.editorController(self, changedToValue: well.color)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            NSColorPanel.sharedColorPanel().showsAlpha = true
            if !(well?.active ?? false) {
                let color = configuration?.value as? NSColor
                well?.color = color ?? NSColor.clearColor()
            }
            
            name?.stringValue = configuration?.label ?? "Color"
        }
    }
}