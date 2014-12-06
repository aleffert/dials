//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

class ConsoleWindowController: NSWindowController, DeviceControllerDelegate {
    
    @IBOutlet var emptyView : NSView?
    @IBOutlet var bodyView : NSView?
    @IBOutlet var connectionOptions : NSPopUpButton?
    
    let deviceController : DeviceController = DeviceController()

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true;
        
        let contentView = (window?.contentView as NSView)
        emptyView?.frame = contentView.bounds;
        emptyView?.autoresizingMask = .ViewHeightSizable | .ViewWidthSizable
        contentView.addSubview(emptyView!)
        
        deviceController.delegate = self
        
        generatePopupMenu()
    }
    
    func deviceControllerUpdatedDevices(controller: DeviceController) {
        generatePopupMenu()
    }
    
    func generatePopupMenu() {
        connectionOptions?.hidden = !deviceController.hasDevices
        
        connectionOptions?.menu?.removeAllItems()
        
        connectionOptions?.menu?.addItemWithTitle(VisibleStrings.ConnectDevice.rawValue, action: nil, keyEquivalent: "")
        connectionOptions?.enabled = false
        
        for device in deviceController.knownDevices {
            connectionOptions?.menu?.addItemWithTitle(device.displayName, action: Selector("choseDeviceOption"), keyEquivalent: "")
        }
    }
    
    func choseDeviceOption(sender : NSMenuItem) {
    }

}
