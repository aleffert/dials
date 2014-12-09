//
//  ConnectionStatusView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

class ConnectionStatusView : NSView {
    
    private let popup : NSPopUpButton = NSPopUpButton(frame: CGRectZero, pullsDown: false)
    private let label : NSTextField = NSTextField(frame: CGRectZero)
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: label, attribute: .CenterY, multiplier: 1, constant: 0))
        label.bordered = false
        label.bezeled = false
        label.editable = false
        label.stringValue = VisibleStrings.NoDevicesFound.rv
        label.backgroundColor = NSColor.clearColor()
        label.alignment = .CenterTextAlignment
        
        self.showNoDevicesLabel(animated: false)
        
        popup.frame = bounds
        popup.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        addSubview(popup)
    }
    
    override var opaque : Bool {
        return false
    }
    
    func showItems(items : [NSMenuItem], animated : Bool = true) {
        let labelView = animated ? label.animator() : label
        let popupView = animated ? popup.animator() : popup
        
        labelView.hidden = true
        popupView.hidden = false

        popup.menu?.removeAllItems()
        items.map { self.popup.menu?.addItem($0) }
    }
    
    func showNoDevicesLabel(animated : Bool = true) {
        let labelView = animated ? label.animator() : label
        let popupView = animated ? popup.animator() : popup
        
        labelView.hidden = false
        popupView.hidden = true
    }
}
