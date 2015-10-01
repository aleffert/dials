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
    func constraintView(constraintView : ConstraintView, updatedConstant constant: CGFloat, constraintID: String)
}

class ConstraintView : NSView, EditConstraintViewControllerDelegate {
    weak var delegate : ConstraintViewDelegate?
    
    @IBOutlet private var info : NSTextField!
    @IBOutlet private var editButton : NSButton!
    
    var constraint : DLSConstraintDescription? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        let area = NSTrackingArea(rect: NSZeroRect, options: [.ActiveInActiveApp, .MouseEnteredAndExited, .InVisibleRect], owner: self, userInfo:nil)
        self.addTrackingArea(area)
        
        let chosenGesture = NSClickGestureRecognizer(target: self, action: Selector("chose:"))
        chosenGesture.numberOfClicksRequired = 2
        info.addGestureRecognizer(chosenGesture)
        
        editButton.hidden = true
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
    
    @IBAction func edit(sender: NSButton) {
        let controller = EditConstraintViewController()
        controller.constraint = self.constraint
        controller.delegate = self
        
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.behavior = NSPopoverBehavior.Transient
        popover.showRelativeToRect(sender.bounds, ofView: sender, preferredEdge: .MinY)
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, choseHighlightViewWithID:viewID)
        }
        editButton.hidden = false
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, clearedHighlightViewWithID:viewID)
        }
        editButton.hidden = true
    }
    
    var fields : (first : String, relation : String, second : String) = ("", "", "") {
        didSet {
            info.stringValue = "\(fields.first) \(fields.relation) \(fields.second)"
        }
    }
    
    func editorController(controller: EditConstraintViewController, changedConstantToValue value: CGFloat) {
        self.constraint?.constant = value
        if let id = self.constraint?.constraintID {
            self.delegate?.constraintView(self, updatedConstant: value, constraintID: id)
        }
    }
}
