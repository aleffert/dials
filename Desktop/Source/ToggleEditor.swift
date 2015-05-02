//
//  ToggleDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSToggleDescription : EditorViewGenerating {
    func generate() -> EditorView {
        let view = EditorView.freshViewFromNib("ToggleEditorView") as! ToggleEditorView
        return view
    }
}

extension DLSToggleDescription : CodeGenerating {
    func objcCodeForValue(value: NSCoding?) -> String {
        if let v = value as? NSNumber {
            return v.boolValue ? "YES" : "NO"
        }
        else {
            return "NO"
        }
    }
    
    func swiftCodeForValue(value: NSCoding?) -> String {
        if let v = value as? NSNumber {
            return v.boolValue ? "true" : "false"
        }
        else {
            return "false"
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
            button?.title = info?.displayName ?? "Option"
        }
    }
}