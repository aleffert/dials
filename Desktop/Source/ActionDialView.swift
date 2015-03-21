//
//  DLSActionDescriptor+LiveDialViewGenerating.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

private class ActionDialViewNibOwner {
    @IBOutlet var view : LiveDialView?
}

extension DLSActionDescription : LiveDialViewGenerating {
    func generate() -> LiveDialView {
        return LiveDialView.freshViewFromNib("ActionDialView")
    }
}

class ActionDialView : LiveDialView {
    
    @IBOutlet var button : NSButton?
    
    @IBAction func buttonPressed(sender : NSButton) {
        dial.map {
            self.delegate?.dialView(self, changedDial: $0, toValue: nil)
        }
    }
    
    override var dial : DLSLiveDial? {
        didSet {
            button?.stringValue = dial!.displayName
        }
    }
}