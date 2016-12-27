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
    
    public func code(forValue value: NSCoding?, language: Language) -> String {
        if let c = value as? NSColor {
            let red = stringFromNumber(c.redComponent, requireIntegerPart:true)
            let green = stringFromNumber(c.greenComponent, requireIntegerPart:true)
            let blue = stringFromNumber(c.blueComponent, requireIntegerPart:true)
            let alpha = stringFromNumber(c.alphaComponent, requireIntegerPart:true)
            switch language {
            case .objC:
                return "[[UIColor alloc] initWithRed:\(red) green:\(green) blue:\(blue) alpha:\(alpha)]"
            case .swift:
                return "UIColor(red:\(red), green:\(green), blue:\(blue), alpha:\(alpha))"
            }
        }
        else {
            return "nil"
        }
    }
}

class ColorEditorView : EditorView {
    
    @IBOutlet fileprivate var well : NSColorWell?
    @IBOutlet fileprivate var name : NSTextField?
    
    @IBAction func colorChanged(_ well : NSColorWell) {
        self.delegate?.editorController(self, changedToValue: well.color)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            NSColorPanel.shared().showsAlpha = true
            if !(well?.isActive ?? false) {
                let color = configuration?.value as? NSColor
                well?.color = color ?? NSColor.clear
            }
            
            name?.stringValue = configuration?.label ?? "Color"
        }
    }
}
