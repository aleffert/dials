//
//  ConstraintView.swift
//  Snaps
//
//  Created by Akiva Leffert on 9/26/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Cocoa


class ConstraintViewOwner : NSObject {
    @IBOutlet var constraintView : ConstraintView?
}

protocol ConstraintViewDelegate : class {
    func constraintView(constraintView : ConstraintView, choseHighlightViewWithID viewID: String)
    func constraintView(constraintView : ConstraintView, clearedHighlightViewWithID viewID: String)
    func constraintView(constraintView : ConstraintView, selectedViewWithID viewID: String)
}

class ConstraintView : NSView {
    weak var delegate : ConstraintViewDelegate?
    
    @IBOutlet private var info : NSTextField!
    
    var constraint : DLSConstraintDescription? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        let area = NSTrackingArea(rect: NSZeroRect, options: [.ActiveInActiveApp, .MouseEnteredAndExited, .InVisibleRect], owner: self, userInfo:nil)
        self.addTrackingArea(area)
        
        let chosenGesture = NSClickGestureRecognizer(target: self, action: Selector("chose:"))
        chosenGesture.numberOfClicksRequired = 2
        self.addGestureRecognizer(chosenGesture)
    }
    
    var complementaryViewID : String? {
        if let viewID = constraint?.sourceViewID where constraint?.affectedViewID != viewID {
            return viewID
        }
        else if let viewID = constraint?.destinationViewID where constraint?.affectedViewID != viewID {
            return viewID
        }
        else {
            return nil
        }
    }
    
    func chose(theEvent: NSEvent) {
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, selectedViewWithID: viewID)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, choseHighlightViewWithID:viewID)
        }
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, clearedHighlightViewWithID:viewID)
        }
    }
    
    var fields : (first : String, relation : String, second : String) = ("", "", "") {
        didSet {
            info.stringValue = "\(fields.first) \(fields.relation) \(fields.second)"
        }
    }
}
