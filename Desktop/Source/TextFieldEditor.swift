//
//  TextFieldEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/1/15.
//
//

import Cocoa

extension DLSTextFieldDescription : EditorViewGenerating {
    func generate() -> EditorView {
        let view = EditorView.freshViewFromNib("TextFieldEditorView") as! TextFieldEditorView
        view.editorDescription = self
        return view
    }
}

extension DLSTextFieldDescription : CodeGenerating {
    func objcCodeForValue(value: NSCoding?) -> String {
        if let s = value as? NSString {
            return "@\"\(s.description)\""
        }
        return "nil"
    }
    
    func swiftCodeForValue(value: NSCoding?) -> String {
        if let s = value as? NSString {
            return "\"\(s.description)\""
        }
        return "nil"
    }
}

class TextFieldEditorView: EditorView {
    
    @IBOutlet private var field : NSTextField?
    @IBOutlet private var name : NSTextField?
    
    var editorDescription : DLSTextFieldDescription? {
        didSet {
            let editable = !(editorDescription?.readOnly ?? true)
            field?.bezeled = editable
            field?.drawsBackground = editable
            field?.editable = editable
            field?.selectable = true
        }
    }
    
    @IBAction func textFieldChanged(sender : NSTextField) {
        delegate?.editorView(self, changedInfo: info!, toValue: sender.stringValue)
    }
    
    override var info : EditorInfo? {
        didSet {
            let content = info?.value as? String
            let firstResponder = field?.window?.firstResponder
            if firstResponder == nil || firstResponder != field?.currentEditor() {
                field?.stringValue = content ?? ""
            }
            name?.stringValue = info?.displayName ?? "Text"
            
        }
    }

}
