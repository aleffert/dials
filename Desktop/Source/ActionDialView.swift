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

class FlippedClipView : NSClipView {
    override var flipped : Bool {
        return true;
    }
}

extension DLSActionDescription : LiveDialViewGenerating {
    func generate() -> LiveDialView {
        var objects : NSArray?
        let owner = ActionDialViewNibOwner()
        NSBundle.mainBundle().loadNibNamed("ActionDialView", owner: owner, topLevelObjects: &objects)
        return owner.view!
    }
}

class ActionDialView : LiveDialView {
    @IBAction func buttonPressed(sender : AnyObject) {
        dial.map {
            self.delegate?.dialView(self, changedDial: $0, toValue: nil)
        }
    }
}