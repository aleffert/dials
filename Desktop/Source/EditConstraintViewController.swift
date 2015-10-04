//
//  EditConstraintViewController.swift
//  Dials
//
//  Created by Akiva Leffert on 9/30/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

protocol EditConstraintViewControllerDelegate : class {
    func editorController(controller : EditConstraintViewController, changedConstantToValue value : CGFloat)
    func editorController(controller : EditConstraintViewController, choseSaveToValue value : CGFloat)
    
}

class EditConstraintViewController : NSViewController {
    
    @IBOutlet var constant : NSTextField?
    @IBOutlet var multiplier : NSTextField?
    @IBOutlet var priority : NSTextField?
    @IBOutlet var constantStepper : NSStepper?
    @IBOutlet var saveButton : NSButton?
    
    weak var delegate : EditConstraintViewControllerDelegate?
    
    override var nibName : String {
        return "EditConstraintViewController"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        constantStepper?.minValue = -Double(FLT_MAX)
        constantStepper?.maxValue = Double(FLT_MAX)
        constantStepper?.increment = 1
        
        updateFromConstraint()
    }
    
    private func updateFromConstraint() {
        constant?.stringValue = stringFromNumber(constraint?.constant ?? 0)
        multiplier?.stringValue = stringFromNumber(constraint?.multiplier ?? 1)
        priority?.stringValue = stringFromNumber(constraint?.priority ?? 0)
        constantStepper?.floatValue = Float(constraint?.constant ?? 0)
        saveButton?.hidden = constraint?.saveExtra == nil
    }
    
    @IBAction func save(sender : NSButton) {
        delegate?.editorController(self, choseSaveToValue: constraint?.constant ?? 0)
    }
    
    @IBAction func textChanged(sender : NSTextField) {
        constantStepper?.floatValue = sender.floatValue
        delegate?.editorController(self, changedConstantToValue: CGFloat(sender.floatValue))
    }
    
    @IBAction func stepperChanged(sender : NSStepper) {
        constant?.floatValue = sender.floatValue
        delegate?.editorController(self, changedConstantToValue: CGFloat(sender.floatValue))
    }
    
    var constraint : DLSConstraintDescription? {
        didSet {
            updateFromConstraint()
        }
    }
}

