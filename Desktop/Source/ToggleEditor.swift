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

    public func code(forValue value: NSCoding?, language: Language) -> String {
        let values : (t : String, f : String)
        
        switch language {
        case .objC:
            values = (t : "YES", f : "NO")
        case .swift:
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
    @IBOutlet fileprivate var button : NSButton?
    
    @IBAction fileprivate func buttonToggled(_ sender : NSButton) {
        self.delegate?.editorController(self, changedToValue: sender.state as NSCoding?)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            let state = configuration?.value as? NSNumber
            button?.state = state?.intValue ?? 0
            button?.title = configuration?.label ?? "Option"
        }
    }
}
