//
//  LiveDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

protocol LiveDialViewDelegate : class {
    func dialView(view : LiveDialView, changedDial dial : DLSLiveDial, toValue value: NSCoding?)
}

private class LiveDialViewNibOwner {
    @IBOutlet var view : LiveDialView?
}

class LiveDialView : NSView {
    weak var delegate : LiveDialViewDelegate?
    var dial : DLSLiveDial?
    
    class func freshViewFromNib(name : String) -> LiveDialView {
        let owner = LiveDialViewNibOwner()
        NSBundle.mainBundle().loadNibNamed(name, owner: owner, topLevelObjects: nil)
        return owner.view!
    }
}

@objc protocol LiveDialViewGenerating : class {
    func generate() -> LiveDialView
}