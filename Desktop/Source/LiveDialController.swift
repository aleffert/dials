//
//  LiveDialController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/19/15.
//
//

import Foundation
import AppKit

protocol LiveDialControllerDelegate : class {
    func dialController(controller : LiveDialController, changedDial dial : DLSLiveDial, toValue value : NSCoding?)
    func dialController(controller : LiveDialController, shouldSaveDial dial : DLSLiveDial, withValue value : NSCoding?)
}

class LiveDialController : NSObject, LiveDialViewDelegate, Equatable {
    @IBOutlet var bodyView : NSView?
    @IBOutlet var containerView : NSView?
    @IBOutlet var revertButton : NSButton?
    @IBOutlet var saveButton : NSButton?
    @IBOutlet var openButton : NSButton?
    
    var currentValue : NSCoding?
    var updated : Bool = false
    var mouseInView : Bool = false

    let contentView : LiveDialView
    
    weak var delegate : LiveDialControllerDelegate?
    
    init(dial : DLSLiveDial, contentView : LiveDialView, delegate : LiveDialControllerDelegate) {
        contentView.dial = dial
        self.delegate = delegate
        self.contentView = contentView
        currentValue = dial.value()
        super.init()
        contentView.delegate = self
        NSBundle.mainBundle().loadNibNamed("LiveDialCellView", owner: self, topLevelObjects: nil)
        bodyView?.translatesAutoresizingMaskIntoConstraints = false
        let area = NSTrackingArea(rect: NSZeroRect, options: .ActiveInActiveApp | .MouseEnteredAndExited | .InVisibleRect, owner: self, userInfo: nil)
        bodyView?.addTrackingArea(area)
        containerView?.addSubview(contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
        validateButtons(animated : false)
    }
    
    func validateButtons(#animated : Bool) {
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.allowsImplicitAnimation = true
            if let d = self.contentView.dial {
                self.revertButton?.enabled = d.editor.canRevert && self.updated
                self.saveButton?.enabled = d.canSave && self.updated
            }
            self.revertButton?.hidden = !self.mouseInView
            self.saveButton?.hidden = !self.mouseInView
            self.openButton?.hidden = !self.mouseInView
        }, completionHandler: nil)
    }
    
    func dialView(view: LiveDialView, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        currentValue = value
        updated = true
        delegate?.dialController(self, changedDial:dial, toValue: value)
        validateButtons(animated: true)
    }
    
    var dial : DLSLiveDial? {
        return contentView.dial
    }
    
    var view : NSView {
        return bodyView!
    }
    
    func mouseEntered(theEvent: NSEvent) {
        mouseInView = true
        validateButtons(animated: true)
    }
    
    func mouseExited(theEvent: NSEvent) {
        mouseInView = false
        validateButtons(animated: true)
    }
    
    @IBAction func openFilePressed(sender : AnyObject) {
        contentView.dial.map { NSWorkspace.sharedWorkspace().openFile($0.file) }
    }
    
    @IBAction func revertPressed(sender : AnyObject) {
        contentView.dial = contentView.dial
        delegate?.dialController(self, changedDial: contentView.dial!, toValue: contentView.dial!.value())
        updated = false
        validateButtons(animated: true)
    }
    
    @IBAction func saveFilePressed(sender : AnyObject) {
        if let d = contentView.dial {
            delegate?.dialController(self, shouldSaveDial : contentView.dial!, withValue: currentValue)
            d.setValue(currentValue)
            updated = false
            validateButtons(animated: true)
        }
    }
}

func < (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.displayName < right.contentView.dial?.displayName
}

func == (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.uuid == right.contentView.dial?.uuid
}