//
//  SliderDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation
import AppKit

extension DLSSliderEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("SliderEditorView") as! SliderEditorView
        view.editor = self
        return view
    }
}

extension DLSSliderEditor : CodeGenerating {
    func codeForValue(value : NSCoding?, language : Language) -> String {
        if let v = value as? NSNumber {
            return stringFromNumber(v, requireIntegerPart: true)
        }
        else {
            return "0"
        }
    }
}

class SliderEditorView : EditorView {
    @IBOutlet private var slider : NSSlider?
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var minLabel : NSTextField?
    @IBOutlet private var maxLabel : NSTextField?
    @IBOutlet private var currentLabel : NSTextField?
    
    var editor : DLSSliderEditor? {
        didSet {
            slider?.minValue = editor!.min
            slider?.maxValue = editor!.max
            minLabel?.stringValue = stringFromNumber(editor!.min)
            maxLabel?.stringValue = stringFromNumber(editor!.max)
        }
    }
    
    @IBAction private func sliderChanged(sender : NSSlider) {
        currentLabel?.stringValue = stringFromNumber(sender.floatValue)
        self.delegate?.editorView(self, changedInfo: info!, toValue: sender.floatValue)
    }
    
    override var info : EditorInfo? {
        didSet {
            let floatValue = (info?.value as? NSNumber)?.floatValue ?? 0
            slider?.floatValue = floatValue
            currentLabel?.stringValue = stringFromNumber(floatValue)
            
            name?.stringValue = info?.label ?? "Slider"
        }
    }
}