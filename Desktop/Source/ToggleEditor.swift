//
//  ToggleDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSToggleEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("ToggleEditorView") as! ToggleEditorView
        return view
    }
}

extension DLSToggleEditor : CodeGenerating {

    public func codeForValue(value: NSCoding?, language: Language) -> String {
        let values : (t : String, f : String)
        
        switch language {
        case .ObjC:
            values = (t : "YES", f : "NO")
        case .Swift:
            values = (t : "true", f : "false")
        }
        
        if let v = value as? NSNumber {
            return v.boolValue ? values.t : values.f
        }
        else {
            return values.f
        }
    }
}

class ToggleEditorView : EditorView {
    @IBOutlet private var button : NSButton?
    
    @IBAction private func buttonToggled(sender : NSButton) {
        self.delegate?.editorController(self, changedToValue: sender.state)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            let state = configuration?.value as? NSNumber
            button?.state = state?.integerValue ?? 0
            button?.title = configuration?.label ?? "Option"
        }
    }
}