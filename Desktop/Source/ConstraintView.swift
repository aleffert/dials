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
    func constraintView(_ constraintView : ConstraintView, choseHighlightViewWithID viewID: String)
    func constraintView(_ constraintView : ConstraintView, clearedHighlightViewWithID viewID: String)
    func constraintView(_ constraintView : ConstraintView, selectedViewWithID viewID: String)
    func constraintView(_ constraintView : ConstraintView, updatedConstant constant: CGFloat, constraintID: String)
    func constraintView(_ constraintView : ConstraintView, savedConstant constant: CGFloat, constraintID: String)
}

class ConstraintView : NSView, EditConstraintViewControllerDelegate {
    weak var delegate : ConstraintViewDelegate?
    
    @IBOutlet fileprivate var info : NSTextField!
    @IBOutlet fileprivate var editButton : NSButton!
    @IBOutlet fileprivate var jumpButton : NSButton!
    
    var constraint : DLSConstraintDescription? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        let area = NSTrackingArea(rect: NSZeroRect, options: [.activeInActiveApp, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo:nil)
        self.addTrackingArea(area)
        
        let chosenGesture = NSClickGestureRecognizer(target: self, action: #selector(ConstraintView.chose(_:)))
        chosenGesture.numberOfClicksRequired = 2
        info.addGestureRecognizer(chosenGesture)
        
        editButton.isHidden = true
        allowsJump = false
    }
    
    var complementaryViewID : String? {
        if let viewID = constraint?.sourceViewID, constraint?.affectedViewID != viewID {
            return viewID
        }
        else if let viewID = constraint?.destinationViewID, constraint?.affectedViewID != viewID {
            return viewID
        }
        else {
            return nil
        }
    }
    
    func chose(_ theEvent: NSEvent) {
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, selectedViewWithID: viewID)
        }
    }
    
    @IBAction func edit(_ sender: NSButton) {
        let controller = EditConstraintViewController()
        controller.constraint = self.constraint
        controller.delegate = self
        
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.behavior = NSPopoverBehavior.transient
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, choseHighlightViewWithID:viewID)
        }
        editButton.isHidden = false
        self.allowsJump = constraint?.locationExtra != nil
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        
        if let viewID = complementaryViewID {
            self.delegate?.constraintView(self, clearedHighlightViewWithID:viewID)
        }
        editButton.isHidden = true
        self.allowsJump = false
    }
    
    var fields : (first : String, relation : String, second : String) = ("", "", "") {
        didSet {
            info.stringValue = "\(fields.first) \(fields.relation) \(fields.second)"
        }
    }
    
    var allowsJump : Bool = false {
        didSet {
            jumpButton.isHidden = !allowsJump
        }
    }
    
    @IBAction func jump(_ sender : NSButton) {
        if let location = constraint?.locationExtra?.location {
            Process.launchedProcess(launchPath: "/usr/bin/xed", arguments: ["-l", location.line.description, location.file])
        }
        else {
            assertionFailure("Jump button pressed, but shouldn't be visible")
        }
    }
    
    func editorController(_ controller: EditConstraintViewController, choseSaveToValue value: CGFloat) {
        if let id = self.constraint?.constraintID {
            self.delegate?.constraintView(self, savedConstant: value, constraintID: id)
        }
    }
    
    func editorController(_ controller: EditConstraintViewController, changedConstantToValue value: CGFloat) {
        self.constraint?.constant = value
        if let id = self.constraint?.constraintID {
            self.delegate?.constraintView(self, updatedConstant: value, constraintID: id)
        }
    }
}
