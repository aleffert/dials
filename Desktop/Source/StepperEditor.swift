//
//  StepperEditor.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/20/15.
//
//

import Cocoa

extension DLSStepperDescription : EditorViewGenerating {
    func generate() -> EditorView {
        let view = EditorView.freshViewFromNib("StepperEditorView") as! StepperEditorView
        view.editorDescription = self
        return view
    }
}

extension DLSStepperDescription : CodeGenerating {
    private func codeForValue(value : NSCoding?) -> String {
        if let v = value as? NSNumber {
            return stringFromNumber(v, requireIntegerPart: true)
        }
        else {
            return "0"
        }
    }
    
    func objcCodeForValue(value: NSCoding?) -> String {
        return codeForValue(value)
    }
    
    func swiftCodeForValue(value: NSCoding?) -> String {
        return codeForValue(value)
    }
}

class StepperEditorView : EditorView {
    @IBOutlet var name : NSTextField?
    @IBOutlet var field : NSTextField?
    @IBOutlet var stepper : NSStepper?

    var editorDescription : DLSStepperDescription? {
        didSet {
            stepper?.minValue = editorDescription!.min
            stepper?.maxValue = editorDescription!.max
            stepper?.increment = editorDescription!.increment
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            let floatValue = (info?.value as? NSNumber)?.floatValue ?? 0
            stepper?.floatValue = floatValue
            field?.floatValue = floatValue
            name?.stringValue = info?.displayName ?? "Stepper"
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