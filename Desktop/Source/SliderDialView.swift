//
//  SliderDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation
import AppKit

extension DLSSliderDescription : LiveDialViewGenerating {
    func generate() -> LiveDialView {
        let view = LiveDialView.freshViewFromNib("SliderDialView") as SliderDialView
        view.editorDescription = self
        return view
    }
}

class SliderDialView : LiveDialView {
    @IBOutlet private var slider : NSSlider?
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var minLabel : NSTextField?
    @IBOutlet private var maxLabel : NSTextField?
    @IBOutlet private var currentLabel : NSTextField?
    
    var editorDescription : DLSSliderDescription? {
        didSet {
            slider?.minValue = editorDescription!.min
            slider?.maxValue = editorDescription!.max
            slider?.continuous = editorDescription!.continuous
            minLabel?.doubleValue = editorDescription!.min
            maxLabel?.doubleValue = editorDescription!.max
        }
    }
    
    @IBAction private func sliderChanged(sender : NSSlider) {
        currentLabel?.stringValue = NSString(format: "%.2f", sender.floatValue)
        self.delegate?.dialView(self, changedDial: dial!, toValue: sender.floatValue)
    }
    
    override var dial : DLSLiveDial? {
        didSet {
            let value = (dial?.value() as? NSNumber)?.floatValue ?? 0
            slider?.floatValue = value
            currentLabel?.stringValue = NSString(format: "%.2f", value)
            
            name?.stringValue = dial?.displayName ?? "Slider"
        }
    }
}