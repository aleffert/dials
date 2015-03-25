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
    
    var currentValue : NSCoding?

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
        containerView?.addSubview(contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
        revertButton?.enabled = dial.editor.canRevert
        saveButton?.enabled = dial.canSave
    }
    
    func dialView(view: LiveDialView, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        currentValue = value
        delegate?.dialController(self, changedDial:dial, toValue: value)
    }
    
    var dial : DLSLiveDial? {
        return contentView.dial
    }
    
    var view : NSView {
        return bodyView!
    }
    
    @IBAction func openFilePressed(sender : AnyObject) {
        contentView.dial.map { NSWorkspace.sharedWorkspace().openFile($0.file) }
    }
    
    @IBAction func revertPressed(sender : AnyObject) {
        contentView.dial = contentView.dial
        delegate?.dialController(self, changedDial: contentView.dial!, toValue: contentView.dial!.value())
    }
    
    @IBAction func saveFilePressed(sender : AnyObject) {
        delegate?.dialController(self, shouldSaveDial : contentView.dial!, withValue: currentValue)
    }
}

func < (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.displayName < right.contentView.dial?.displayName
}

func == (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.uuid == right.contentView.dial?.uuid
}