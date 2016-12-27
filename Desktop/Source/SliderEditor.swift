//
//  SliderDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation
import AppKit

extension DLSSliderEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("SliderEditorView") as! SliderEditorView
        view.editor = self
        return view
    }
}

extension DLSSliderEditor : CodeGenerating {
    public func code(forValue value : NSCoding?, language : Language) -> String {
        if let v = value as? NSNumber {
            return stringFromNumber(v, requireIntegerPart: true)
        }
        else {
            return "0"
        }
    }
}

class SliderEditorView : EditorView {
    @IBOutlet fileprivate var slider : NSSlider?
    @IBOutlet fileprivate var name : NSTextField?
    @IBOutlet fileprivate var minLabel : NSTextField?
    @IBOutlet fileprivate var maxLabel : NSTextField?
    @IBOutlet fileprivate var currentLabel : NSTextField?
    
    var editor : DLSSliderEditor? {
        didSet {
            slider?.minValue = editor!.min
            slider?.maxValue = editor!.max
            minLabel?.stringValue = stringFromNumber(editor!.min)
            maxLabel?.stringValue = stringFromNumber(editor!.max)
        }
    }
    
    @IBAction fileprivate func sliderChanged(_ sender : NSSlider) {
        currentLabel?.stringValue = stringFromNumber(sender.floatValue)
        self.delegate?.editorController(self, changedToValue: sender.floatValue as NSCoding?)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            if !(slider?.isHighlighted ?? false) {
                let floatValue = (configuration?.value as? NSNumber)?.floatValue ?? 0
                slider?.floatValue = floatValue
                currentLabel?.stringValue = stringFromNumber(floatValue)
                
            }
            name?.stringValue = configuration?.label ?? "Slider"
        }
    }
}
