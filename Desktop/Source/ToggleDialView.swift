//
//  ToggleDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Cocoa

extension DLSToggleDescription : LiveDialViewGenerating {
    func generate() -> LiveDialView {
        let view = LiveDialView.freshViewFromNib("ToggleDialView") as ToggleDialView
        return view
    }
}

extension DLSToggleDescription : CodeGenerating {
    func objcCodeForValue(value: NSCoding?) -> String {
        if let v = value as? NSNumber {
            return v.boolValue ? "YES" : "NO"
        }
        else {
            return "NO"
        }
    }
    
    func swiftCodeForValue(value: NSCoding?) -> String {
        if let v = value as? NSNumber {
            return v.boolValue ? "true" : "false"
        }
        else {
            return "false"
        }
    }
}

class ToggleDialView : LiveDialView {
    @IBOutlet private var button : NSButton?
    
    @IBAction private func buttonToggled(sender : NSButton) {
        self.delegate?.dialView(self, changedDial: dial!, toValue: sender.state)
    }
    
    override var dial : DLSLiveDial? {
        didSet {
            let value = dial?.value() as? NSNumber
            button?.state = value?.integerValue ?? 0
            button?.title = dial?.displayName ?? "Option"
        }
    }
}