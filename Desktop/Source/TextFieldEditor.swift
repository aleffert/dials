//
//  TextFieldEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/1/15.
//
//

import Cocoa

extension DLSTextFieldEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("TextFieldEditorView") as! TextFieldEditorView
        view.editor = self
        return view
    }
}

extension DLSTextFieldEditor : CodeGenerating {
    
    public func code(forValue value: NSCoding?, language: Language) -> String {
        let prefix : String
        switch language {
        case .objC:
            prefix = "@"
        case .swift:
            prefix = ""
        }
        if let s = value as? NSString {
            return prefix + "\"\(s.description)\""
        }
        return "nil"
    }
}

class TextFieldEditorView: EditorView {
    
    @IBOutlet fileprivate var field : NSTextField?
    @IBOutlet fileprivate var name : NSTextField?
    
    var editor : DLSTextFieldEditor? {
        didSet {
            let editable = (editor?.isEditable ?? false)
            field?.isBezeled = editable
            field?.drawsBackground = editable
            field?.isEditable = editable
            field?.isSelectable = true
        }
    }
    
    @IBAction func textFieldChanged(_ sender : NSTextField) {
        if editor?.isEditable ?? false {
            delegate?.editorController(self, changedToValue: sender.stringValue as NSCoding?)
        }
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            let content = configuration?.value as? String
            let firstResponder = field?.window?.firstResponder
            if firstResponder == nil || firstResponder != field?.currentEditor() {
                field?.stringValue = content ?? ""
            }
            name?.stringValue = configuration?.label ?? "Text"
            
        }
    }

    override var readOnly : Bool {
        return field?.isEditable ?? false
    }
}
