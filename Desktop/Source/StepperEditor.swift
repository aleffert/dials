//
//  StepperEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/20/15.
//
//

import Cocoa

extension DLSStepperEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("StepperEditorView") as! StepperEditorView
        view.editor = self
        return view
    }
}

extension DLSStepperEditor : CodeGenerating {
    
    func codeForValue(value: NSCoding?, language: Language) -> String {
        if let v = value as? NSNumber {
            return stringFromNumber(v, requireIntegerPart: true)
        }
        else {
            return "0"
        }
    }
    
}

class StepperEditorView : EditorView {
    @IBOutlet var name : NSTextField?
    @IBOutlet var field : NSTextField?
    @IBOutlet var stepper : NSStepper?

    var editor : DLSStepperEditor? {
        didSet {
            stepper?.minValue = editor!.min
            stepper?.maxValue = editor!.max
            stepper?.increment = editor!.increment
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            let floatValue = (info?.value as? NSNumber)?.floatValue ?? 0
            stepper?.floatValue = floatValue
            field?.floatValue = floatValue
            name?.stringValue = info?.label ?? "Stepper"
        }
    }
    
    @IBAction func textChanged(sender : NSTextField) {
        stepper?.floatValue = field?.floatValue ?? 0
        delegate?.editorView(self, changedInfo: info!, toValue: sender.floatValue)
    }
    
    @IBAction func stepperChanged(sender : NSStepper) {
        field?.floatValue = sender.floatValue
        delegate?.editorView(self, changedInfo: info!, toValue: sender.floatValue)
    }

}