//
//  StepperEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/20/15.
//
//

import Cocoa

extension DLSStepperEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("StepperEditorView") as! StepperEditorView
        view.editor = self
        return view
    }
}

extension DLSStepperEditor : CodeGenerating {
    
    public func codeForValue(value: NSCoding?, language: Language) -> String {
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
    
    override var configuration : EditorConfiguration? {
        didSet {
            let floatValue = (configuration?.value as? NSNumber)?.floatValue ?? 0
            stepper?.floatValue = floatValue
            field?.floatValue = floatValue
            name?.stringValue = configuration?.label ?? "Stepper"
        }
    }
    
    @IBAction func textChanged(sender : NSTextField) {
        stepper?.floatValue = field?.floatValue ?? 0
        delegate?.editorController(self, changedToValue: sender.floatValue)
    }
    
    @IBAction func stepperChanged(sender : NSStepper) {
        field?.floatValue = sender.floatValue
        delegate?.editorController(self, changedToValue: sender.floatValue)
    }

}