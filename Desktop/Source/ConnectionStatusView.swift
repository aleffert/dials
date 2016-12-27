//
//  ConnectionStatusView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

enum ConnectionStatus {
    case none
    case active(current: Device, all : [Device])
    case available([Device])
}

class ConnectionStatusView : NSView {
    
    private let popup : NSPopUpButton = NSPopUpButton(frame: CGRect.zero, pullsDown: false)
    private let label : NSTextField = NSTextField(frame: CGRect.zero)
    
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
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0))
        label.isBordered = false
        label.isBezeled = false
        label.isEditable = false
        label.stringValue = VisibleStrings.NoDevicesFound.rv
        label.backgroundColor = NSColor.clear
        label.alignment = .center
        
        self.showNoDevicesLabel(animated: false)
        
        popup.frame = bounds
        popup.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        addSubview(popup)
    }
    
    override var isOpaque : Bool {
        return false
    }
    
    private func showDevices(_ devices : [Device], current : Device?, animated : Bool = true) {
        NSAnimationContext.runAnimationGroup({ (ctx) -> Void in
            ctx.duration = animated ? 0.2 : 0
            self.label.animator().isHidden = true
            self.popup.animator().isHidden = false
            }, completionHandler: nil)
        
        let action = #selector(ConsoleWindowController.choseDeviceOption(_:))
        var allDevices = devices

        popup.removeAllItems()
        var items : [NSMenuItem] = []
        if let d = current {
            items.append(NSMenuItem(title : VisibleStrings.Disconnect.rv, action : action, keyEquivalent : ""))
            if allDevices.index(of: d) == nil {
                allDevices.insert(d, at: 0)
            }
        }
        else {
            items.append(NSMenuItem(title : VisibleStrings.NoDeviceSelected.rv, action: nil, keyEquivalent: ""))
        }
        items.append(NSMenuItem.separator())
        
        for device in allDevices {
            let item = NSMenuItem(title : device.label, action: action, keyEquivalent: "")
            item.representedObject = device
            items.append(item)
        }
        for item in items {
            self.popup.menu?.addItem(item)
            if current?.isEqual(item.representedObject) ?? false {
                self.popup.select(item)
            }
        }
        popup.synchronizeTitleAndSelectedItem()
    }
    
    private func showNoDevicesLabel(animated : Bool = true) {
        NSAnimationContext.runAnimationGroup({ (ctx) -> Void in
            ctx.duration = animated ? 0.2 : 0
            self.label.animator().isHidden = false
            self.popup.animator().isHidden = true
            }, completionHandler: nil)
    }
    
    func useStatus(_ status : ConnectionStatus) {
        switch status {
        case .none: showNoDevicesLabel(animated:true)
        case let .available(devices): showDevices(devices, current : nil, animated: true)
        case let .active(current : current, all : devices): showDevices(devices, current : current, animated : true)
        }
    }
}
