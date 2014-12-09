//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

class NamedGroup<A> {
    var items : [A] = []
    var name : String
    
    init(name : String) {
        self.name = name
    }
}

class ConsoleWindowController: NSWindowController {
    
    @IBOutlet private var emptyView : NSView!
    @IBOutlet private var bodyView : NSView!
    
    private let deviceController : DeviceController = DeviceController()
    private var currentConnection : DeviceConnection?
    
    private let pluginController : PluginController = PluginController()
    private let itemsChangedBroadcaster : Broadcaster<ConnectionStatus> = Broadcaster()
    
    private var controllers : [NamedGroup<NSViewController>] = []
    
    override func awakeFromNib() {
        window?.titleVisibility = .Hidden
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true;
        let toolbar = NSToolbar(identifier: "ConsoleWindowToolbarIdentifier")
        toolbar.delegate = self
        toolbar.visible = true
        window?.toolbar = toolbar
        window?.movableByWindowBackground = true
        
        let contentView = (window?.contentView as NSView)
        emptyView?.frame = contentView.bounds;
        emptyView?.autoresizingMask = .ViewHeightSizable | .ViewWidthSizable
        contentView.addSubview(emptyView!)
        
        deviceController.delegate = self
        deviceController.start()
        
        generatePopupMenu()
    }
    
    private func generatePopupMenu() {
        
        var items : [NSMenuItem] = []
        
        if deviceController.hasDevices {
            items.append(NSMenuItem(title : VisibleStrings.NoDeviceSelected.rv, action: nil, keyEquivalent: ""))
            items.append(NSMenuItem.separatorItem())
            
            for device in deviceController.knownDevices {
                let item = NSMenuItem(title : device.displayName, action: Selector("choseDeviceOption:"), keyEquivalent: "")
                item.representedObject = device
                items.append(item)
            }
            
            itemsChangedBroadcaster.notifyListeners(.Available(items))
        }
        else {
            itemsChangedBroadcaster.notifyListeners(.None)
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

extension ConsoleWindowController : NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
        return [NSToolbarFlexibleSpaceItemIdentifier, ConnectionStatusToolbarItemIdentifier]
    }
    
    func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
        return [NSToolbarFlexibleSpaceItemIdentifier, ConnectionStatusToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier]
    }
    
    func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == ConnectionStatusToolbarItemIdentifier {
            return ConnectionStatusToolbarItem(changeBroadcaster: itemsChangedBroadcaster)
        }
        else {
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
}

extension ConsoleWindowController : PluginContext {
    func addViewController(controller: NSViewController, plugin: Plugin) {
        for group in controllers {
            if group.name == plugin.name {
                group.items.append(controller)
                return
            }
        }
        
        let group = NamedGroup<NSViewController>(name : plugin.name)
        group.items.append(controller)
        controllers.append(group)
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        for group in controllers {
            if group.name == plugin.name {
                group.items.filter { return $0 != controller }
            }
        }
    }
    
    func sendMessage(data: NSData, channel: DLSChannel, plugin: Plugin) {
        self.currentConnection?.sendMessage(data, channel : channel)
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
    
    func connection(connection: DeviceConnection, receivedData: NSData, channel: DLSOwnedChannel) {
        pluginController.routeMessage(receivedData, channel : channel)
        NSLog("channel is \(channel)")
    }
    
}
