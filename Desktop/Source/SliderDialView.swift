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
        view.typeDescription = self
        return view
    }
}

class SliderDialView : LiveDialView {
    @IBOutlet private var slider : NSSlider?
    @IBOutlet private var name : NSTextField?
    
    var typeDescription : DLSSliderDescription? {
        didSet {
            slider?.minValue = typeDescription!.min
            slider?.maxValue = typeDescription!.max
            slider?.continuous = typeDescription!.continuous
        }
    }
    
    @IBAction private func sliderChanged(sender : NSSlider) {
        self.delegate?.dialView(self, changedDial: dial!, toValue: sender.floatValue)
    }
    
    override var dial : DLSLiveDial? {
        didSet {
            let value = dial?.value() as? NSNumber
            slider?.floatValue = value?.floatValue ?? 0
            
            name?.stringValue = dial?.displayName ?? "Slider"
        }
    }
}