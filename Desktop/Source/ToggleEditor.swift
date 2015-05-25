//
//  ToggleDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSToggleEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("ToggleEditorView") as! ToggleEditorView
        return view
    }
}

extension DLSToggleEditor : CodeGenerating {

    func codeForValue(value: NSCoding?, language: Language) -> String {
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
        self.delegate?.editorView(self, changedInfo: info!, toValue: sender.state)
    }
    
    override var info : EditorInfo? {
        didSet {
            let state = info?.value as? NSNumber
            button?.state = state?.integerValue ?? 0
            button?.title = info?.label ?? "Option"
        }
    }
}