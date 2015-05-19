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

class LiveDialController : NSObject, EditorViewDelegate, Equatable {
    @IBOutlet var bodyView : NSView?
    @IBOutlet var containerView : NSView?
    @IBOutlet var revertButton : NSButton?
    @IBOutlet var saveButton : NSButton?
    @IBOutlet var openButton : NSButton?
    
    private var currentValue : NSCoding?
    private var updated : Bool = false
    private var mouseInView : Bool = false

    private let contentView : EditorView
    let dial : DLSLiveDial
    
    weak var delegate : LiveDialControllerDelegate?
    
    init(dial : DLSLiveDial, contentView : EditorView, delegate : LiveDialControllerDelegate) {
        contentView.info = EditorInfo(editor : dial.editor, name : dial.label, label : dial.label, value : dial.value())
        self.dial = dial
        self.delegate = delegate
        self.contentView = contentView
        currentValue = dial.value()
        super.init()
        contentView.delegate = self
        NSBundle.mainBundle().loadNibNamed("LiveDialCellView", owner: self, topLevelObjects: nil)
        bodyView?.translatesAutoresizingMaskIntoConstraints = false
        let area = NSTrackingArea(rect: NSZeroRect, options: .ActiveInActiveApp | .MouseEnteredAndExited | .InVisibleRect, owner: self, userInfo: nil)
        let currentBody = bodyView
        self.dls_performActionOnDealloc {
            currentBody?.removeTrackingArea(area)
        }
        bodyView?.addTrackingArea(area)
        containerView?.addSubview(contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
        validateButtons(animated : false)
    }
    
    func validateButtons(#animated : Bool) {
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.allowsImplicitAnimation = true
            self.revertButton?.enabled = self.contentView.readOnly && self.updated
            self.saveButton?.enabled = self.dial.canSave && self.updated && self.dial.file != nil
            self.revertButton?.hidden = !self.mouseInView
            self.saveButton?.hidden = !self.mouseInView
            self.openButton?.hidden = !self.mouseInView
        }, completionHandler: nil)
    }
    
    func editorView(view: EditorView, changedInfo info: EditorInfo, toValue value: NSCoding?) {
        currentValue = value
        updated = true
        delegate?.dialController(self, changedDial:dial, toValue: value)
        validateButtons(animated: true)
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
        dial.file.map { NSWorkspace.sharedWorkspace().openFile($0) }
    }
    
    @IBAction func revertPressed(sender : AnyObject) {
        contentView.info = contentView.info
        delegate?.dialController(self, changedDial: dial, toValue: contentView.info!.value)
        updated = false
        validateButtons(animated: true)
    }
    
    @IBAction func saveFilePressed(sender : AnyObject) {
        delegate?.dialController(self, shouldSaveDial : dial, withValue: currentValue)
        dial.setValue(currentValue)
        updated = false
        validateButtons(animated: true)
    }
}

func < (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.dial.label < right.dial.label
}

func == (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.dial.uuid == right.dial.uuid
}