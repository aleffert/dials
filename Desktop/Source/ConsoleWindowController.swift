//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

class ConsoleWindowController: NSWindowController, DeviceControllerDelegate {
    
    @IBOutlet private var emptyView : NSView!
    @IBOutlet private var bodyView : NSView!
    @IBOutlet private var connectionOptions : NSPopUpButton!
    @IBOutlet private var connectPrompt : NSTextField!
    
    private let deviceController : DeviceController = DeviceController()
    private var currentConnection : DeviceConnection?

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
    private func generatePopupMenu() {
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
    
    func connectToDevice(device : Device?) {
        currentConnection?.close()
        currentConnection = device?.openConnection(delegate : self)
    }
    
    func choseDeviceOption(sender : NSMenuItem) {
        let device = sender.representedObject as Device?
        if currentConnection != nil && currentConnection!.isConnectedToDevice(device) {
            deviceController.saveLastDevice(device)
            connectToDevice(device)
        }
    }
}

extension ConsoleWindowController : DeviceControllerDelegate {
    
    func deviceControllerUpdatedDevices(controller: DeviceController) {
        generatePopupMenu()
    }
    
}

extension ConsoleWindowController : DeviceConnectionDelegate {
    
    func connectionClosed(connection: DeviceConnection) {
        currentConnection = nil;
    }
    
    func connection(connection: DeviceConnection, receivedData: NSData, header: [String : String]) {
        NSLog("header is \(header)")
    }
    
}
