//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

class ConsoleWindowController: NSWindowController, DeviceControllerDelegate {
    
    @IBOutlet var emptyView : NSView!
    @IBOutlet var bodyView : NSView!
    @IBOutlet var connectionOptions : NSPopUpButton!
    @IBOutlet var connectPrompt : NSTextField!
    
    let deviceController : DeviceController = DeviceController()

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true;
        
        let contentView = (window?.contentView as NSView)
        emptyView?.frame = contentView.bounds;
        emptyView?.autoresizingMask = .ViewHeightSizable | .ViewWidthSizable
        contentView.addSubview(emptyView!)
        
        deviceController.delegate = self
        deviceController.start()
        
        generatePopupMenu()
    }
    
    func deviceControllerUpdatedDevices(controller: DeviceController) {
        generatePopupMenu()
    }
    
    func generatePopupMenu() {
        connectionOptions.hidden = !deviceController.hasDevices
        connectPrompt.hidden = !connectionOptions!.hidden
        
        connectionOptions.menu?.removeAllItems()
        
        connectionOptions.menu?.addItemWithTitle(VisibleStrings.NoDeviceSelected.rv, action: nil, keyEquivalent: "")
        
        for device in deviceController.knownDevices {
            let item = NSMenuItem(title : device.displayName, action: Selector("choseDeviceOption:"), keyEquivalent: "")
            item.representedObject = device
            connectionOptions.menu?.addItem(item)
        }
    }
    
    func choseDeviceOption(sender : NSMenuItem) {
    }

}
