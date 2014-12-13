//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

class ConsoleWindowController: NSWindowController {
    
    @IBOutlet private var emptyView : NSView!
    @IBOutlet private var bodyView : NSView!
    @IBOutlet private var titleBarBackground : NSVisualEffectView?
    
    private let deviceController : DeviceController = DeviceController()
    private var currentConnection : DeviceConnection?
    
    private let pluginController : PluginController = PluginController()
    private let viewGrouper : ViewControllerGrouper = ViewControllerGrouper()
    private let itemsChangedBroadcaster : Broadcaster<ConnectionStatus> = Broadcaster()
    private let sidebarController = SidebarSplitViewController(nibName : "SidebarSplitView", bundle : nil)!
    
    override func awakeFromNib() {
        window?.titleVisibility = .Hidden
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true;
        window?.movableByWindowBackground = true
        
        deviceController.delegate = self
        deviceController.start()
        
        devicesChanged()
        
        let contentView = window?.contentView as NSView
        contentView.addSubview(sidebarController.view, positioned: .Below, relativeTo: emptyView)
        sidebarController.view.hidden = true
        sidebarController.view.addConstraintsMatchingSuperviewBounds()
        
        contentView.superview?.addConstraint(NSLayoutConstraint(item: titleBarBackground!, attribute: .Bottom, relatedBy: .Equal, toItem: window?.contentLayoutGuide, attribute: .Top, multiplier: 1, constant: 0))
    }
    
    private func devicesChanged() {
        if let device = currentConnection?.device {
            itemsChangedBroadcaster.notifyListeners(.Active(current : device, all : deviceController.knownDevices))
        }
        else if deviceController.hasDevices {
            itemsChangedBroadcaster.notifyListeners(.Available(deviceController.knownDevices))
        }
        else {
            itemsChangedBroadcaster.notifyListeners(.None)
        }
    }
    
    func connectToDevice(device : Device?) {
        currentConnection?.close()
        currentConnection = device?.openConnection(delegate : self)
        showSidebarIfNecessary()
        hideSidebarIfNecessary()
        devicesChanged()
    }
    
    func choseDeviceOption(sender : NSMenuItem) {
        let device = (sender.representedObject as Device?)
        deviceController.saveLastDevice(device)
        connectToDevice(device)
    }
    
    func showSidebarIfNecessary() {
        if currentConnection != nil && !self.emptyView.hidden {
            self.emptyView.animator().hidden = true
            self.sidebarController.view.animator().hidden = false
        }
        
        if viewGrouper.hasMultipleItems {
            sidebarController.showSidebar()
        }
    }
    
    func hideSidebarIfNecessary() {
        if currentConnection == nil && self.emptyView.hidden {
            self.emptyView.animator().hidden = false
            self.sidebarController.view.animator().hidden = true
        }
        
        if !viewGrouper.hasMultipleItems {
            sidebarController.hideSidebar()
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
        viewGrouper.addViewController(controller, groupName : plugin.name)
        showSidebarIfNecessary()
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        viewGrouper.removeViewController(controller, groupName : plugin.name)
        hideSidebarIfNecessary()
    }
    
    func sendMessage(data: NSData, channel: DLSChannel, plugin: Plugin) {
        self.currentConnection?.sendMessage(data, channel : channel)
    }
}

extension ConsoleWindowController : DeviceControllerDelegate {
    
    func deviceControllerUpdatedDevices(controller: DeviceController) {
        devicesChanged()
    }
    
}

extension ConsoleWindowController : DeviceConnectionDelegate {
    
    func connectionClosed(connection: DeviceConnection) {
        pluginController.connectionClosed()
        currentConnection = nil;
        hideSidebarIfNecessary()
    }
    
    func connection(connection: DeviceConnection, receivedData: NSData, channel: DLSOwnedChannel) {
        pluginController.routeMessage(receivedData, channel : channel)
    }
    
}
