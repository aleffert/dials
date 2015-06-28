//
//  ControlController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/19/15.
//
//

import Foundation
import AppKit

protocol ControlControllerDelegate : class {
    func controlController(controller : ControlController, changedControlInfo info : DLSControlInfo, toValue value : NSCoding?)
    func controlController(controller : ControlController, shouldSaveControlInfo info : DLSControlInfo, withValue value : NSCoding?)
}

class ControlController : NSObject, EditorViewDelegate, Equatable {
    @IBOutlet var bodyView : NSView?
    @IBOutlet var containerView : NSView?
    @IBOutlet var revertButton : NSButton?
    @IBOutlet var saveButton : NSButton?
    @IBOutlet var openButton : NSButton?
    
    private var currentValue : NSCoding?
    private var updated : Bool = false
    private var mouseInView : Bool = false

    private let contentView : EditorView
    let controlInfo : DLSControlInfo
    
    weak var delegate : ControlControllerDelegate?
    
    init(controlInfo : DLSControlInfo, contentView : EditorView, delegate : ControlControllerDelegate) {
        contentView.info = EditorInfo(editor : controlInfo.editor, name : controlInfo.label, label : controlInfo.label, value : controlInfo.value())
        self.controlInfo = controlInfo
        self.delegate = delegate
        self.contentView = contentView
        currentValue = controlInfo.value()
        super.init()
        contentView.delegate = self
        NSBundle.mainBundle().loadNibNamed("ControlCellView", owner: self, topLevelObjects: nil)
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
            self.saveButton?.enabled = self.controlInfo.canSave && self.updated && self.controlInfo.file != nil
            self.revertButton?.hidden = !self.mouseInView
            self.saveButton?.hidden = !self.mouseInView
            self.openButton?.hidden = !self.mouseInView
        }, completionHandler: nil)
    }
    
    func editorView(view: EditorView, changedInfo info: EditorInfo, toValue value: NSCoding?) {
        currentValue = value
        updated = true
        delegate?.controlController(self, changedControlInfo:controlInfo, toValue: value)
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
        controlInfo.file.map { NSWorkspace.sharedWorkspace().openFile($0) }
    }
    
    @IBAction func revertPressed(sender : AnyObject) {
        contentView.info = contentView.info
        delegate?.controlController(self, changedControlInfo: controlInfo, toValue: contentView.info!.value)
        updated = false
        validateButtons(animated: true)
    }
    
    @IBAction func saveFilePressed(sender : AnyObject) {
        delegate?.controlController(self, shouldSaveControlInfo : controlInfo, withValue: currentValue)
        controlInfo.setValue(currentValue)
        updated = false
        validateButtons(animated: true)
    }
}

func < (left : ControlController, right : ControlController) -> Bool {
    return left.controlInfo.label < right.controlInfo.label
}

func == (left : ControlController, right : ControlController) -> Bool {
    return left.controlInfo.uuid == right.controlInfo.uuid
}