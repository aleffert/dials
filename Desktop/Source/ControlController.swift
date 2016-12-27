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
    func controlController(_ controller : ControlController, changedControlInfo info : DLSControlInfo, toValue value : NSCoding?)
    func controlController(_ controller : ControlController, shouldSaveControlInfo info : DLSControlInfo, withValue value : NSCoding?)
}

class ControlController : NSObject, EditorControllerDelegate {
    @IBOutlet var bodyView : NSView?
    @IBOutlet var containerView : NSView?
    @IBOutlet var revertButton : NSButton?
    @IBOutlet var saveButton : NSButton?
    @IBOutlet var openButton : NSButton?
    
    fileprivate var currentValue : NSCoding?
    fileprivate var updated : Bool = false
    fileprivate var mouseInView : Bool = false

    fileprivate let contentController : EditorController
    let controlInfo : DLSControlInfo
    
    weak var delegate : ControlControllerDelegate?
    
    init(controlInfo : DLSControlInfo, contentController : EditorController, delegate : ControlControllerDelegate) {
        contentController.configuration = EditorInfo(editor : controlInfo.editor, name : controlInfo.label, label : controlInfo.label, value : controlInfo.value)
        self.controlInfo = controlInfo
        self.delegate = delegate
        self.contentController = contentController
        currentValue = controlInfo.value
        super.init()
        contentController.delegate = self
        Bundle.main.loadNibNamed("ControlCellView", owner: self, topLevelObjects: nil)
        bodyView?.translatesAutoresizingMaskIntoConstraints = false
        let area = NSTrackingArea(rect: NSZeroRect, options: [.activeInActiveApp, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo: nil)
        let currentBody = bodyView
        self.dls_performAction {
            currentBody?.removeTrackingArea(area)
        }
        bodyView?.addTrackingArea(area)
        containerView?.addSubview(contentController.view)
        contentController.view.addConstraintsMatchingSuperviewBounds()
        validateButtons(animated : false)
    }
    
    func validateButtons(animated : Bool) {
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.allowsImplicitAnimation = true
            self.revertButton?.isEnabled = self.updated
            self.saveButton?.isEnabled = self.controlInfo.canSave && self.updated && self.controlInfo.file != nil
            self.revertButton?.isHidden = !self.mouseInView
            self.saveButton?.isHidden = !self.mouseInView
            self.openButton?.isHidden = !self.mouseInView
        }, completionHandler: nil)
    }
    
    func editorController(_ controller: EditorController, changedToValue value: NSCoding?) {
        currentValue = value
        updated = true
        delegate?.controlController(self, changedControlInfo:controlInfo, toValue: value)
        validateButtons(animated: true)
    }
    
    var view : NSView {
        return bodyView!
    }
    
    func mouseEntered(_ theEvent: NSEvent) {
        mouseInView = true
        validateButtons(animated: true)
    }
    
    func mouseExited(_ theEvent: NSEvent) {
        mouseInView = false
        validateButtons(animated: true)
    }
    
    @IBAction func openFilePressed(_ sender : AnyObject) {
        if let file = controlInfo.file {
            Process.launchedProcess(launchPath: "/usr/bin/xed", arguments: ["--line", controlInfo.line.description, file])
        }
    }
    
    @IBAction func revertPressed(_ sender : AnyObject) {
        contentController.configuration = contentController.configuration
        delegate?.controlController(self, changedControlInfo: controlInfo, toValue: contentController.configuration!.value)
        updated = false
        validateButtons(animated: true)
    }
    
    @IBAction func saveFilePressed(_ sender : AnyObject) {
        delegate?.controlController(self, shouldSaveControlInfo : controlInfo, withValue: currentValue)
        controlInfo.value = currentValue
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
