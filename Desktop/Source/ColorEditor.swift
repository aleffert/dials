//
//  ColorEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSColorEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        return EditorView.freshViewFromNib("ColorEditorView")
    }
}

extension DLSColorEditor : CodeGenerating {
    
    func codeForValue(value: NSCoding?, language: Language) -> String {
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
        if let info = info {
            self.delegate?.editorView(self, changedInfo: info, toValue: well.color)
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            NSColorPanel.sharedColorPanel().showsAlpha = true
            
            let color = info?.value as? NSColor
            well?.color = color ?? NSColor.clearColor()
            
            name?.stringValue = info?.label ?? "Color"
        }
    }
}