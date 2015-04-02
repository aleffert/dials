//
//  ConnectionStatusView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

enum ConnectionStatus {
    case None
    case Active(current: Device, all : [Device])
    case Available([Device])
}

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
    
    private func showDevices(devices : [Device], current : Device?, animated : Bool = true) {
        NSAnimationContext.runAnimationGroup({ (ctx) -> Void in
            ctx.duration = animated ? 0.2 : 0
            self.label.animator().hidden = true
            self.popup.animator().hidden = false
            }, completionHandler: nil)
        
        let action = Selector("choseDeviceOption:")
        var allDevices = devices

        popup.removeAllItems()
        var items : [NSMenuItem] = []
        if let d = current {
            items.append(NSMenuItem(title : VisibleStrings.Disconnect.rv, action : action, keyEquivalent : ""))
            if find(allDevices, d) == nil {
                allDevices.insert(d, atIndex: 0)
            }
        }
        else {
            items.append(NSMenuItem(title : VisibleStrings.NoDeviceSelected.rv, action: nil, keyEquivalent: ""))
        }
        items.append(NSMenuItem.separatorItem())
        
        for device in allDevices {
            let item = NSMenuItem(title : device.displayName, action: action, keyEquivalent: "")
            item.representedObject = device
            items.append(item)
        }
        items.map {item -> Void in
            self.popup.menu?.addItem(item)
            if current?.isEqual(item.representedObject) ?? false {
                self.popup.selectItem(item)
            }
            return
        }
        popup.synchronizeTitleAndSelectedItem()
    }
    
    private func showNoDevicesLabel(animated : Bool = true) {
        NSAnimationContext.runAnimationGroup({ (ctx) -> Void in
            ctx.duration = animated ? 0.2 : 0
            self.label.animator().hidden = false
            self.popup.animator().hidden = true
            }, completionHandler: nil)
    }
    
    func useStatus(status : ConnectionStatus) {
        switch status {
        case .None: showNoDevicesLabel(animated: true)
        case let .Available(devices): showDevices(devices, current : nil, animated: true)
        case let .Active(current : current, devices : devices): showDevices(devices, current : current, animated : true)
        }
    }
}
