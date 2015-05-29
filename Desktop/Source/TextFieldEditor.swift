//
//  TextFieldEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/1/15.
//
//

import Cocoa

extension DLSTextFieldEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("TextFieldEditorView") as! TextFieldEditorView
        view.editor = self
        return view
    }
}

extension DLSTextFieldEditor : CodeGenerating {
    
    func codeForValue(value: NSCoding?, language: Language) -> String {
        let prefix : String
        switch language {
        case .ObjC:
            prefix = "@"
        case .Swift:
            prefix = ""
        }
        if let s = value as? NSString {
            return prefix + "\"\(s.description)\""
        }
        return "nil"
    }
}

class TextFieldEditorView: EditorView {
    
    @IBOutlet private var field : NSTextField?
    @IBOutlet private var name : NSTextField?
    
    var editor : DLSTextFieldEditor? {
        didSet {
            let editable = (editor?.editable ?? false)
            field?.bezeled = editable
            field?.drawsBackground = editable
            field?.editable = editable
            field?.selectable = true
        }
    }
    
    @IBAction func textFieldChanged(sender : NSTextField) {
        if editor?.editable ?? false {
            delegate?.editorView(self, changedInfo: info!, toValue: sender.stringValue)
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            let content = info?.value as? String
            let firstResponder = field?.window?.firstResponder
            if firstResponder == nil || firstResponder != field?.currentEditor() {
                field?.stringValue = content ?? ""
            }
            name?.stringValue = info?.label ?? "Text"
            
        }
    }

    override var readOnly : Bool {
        return field?.editable ?? false
    }
}
