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
    @IBOutlet private var sidebarTable : NSTableView!
    
    @IBOutlet private var bodyController : NSViewController!
    
    private let deviceController : DeviceController = DeviceController()
    private var currentConnection : DeviceConnection?
    
    private let pluginController : PluginController = PluginController()
    private let viewGrouper : ViewControllerGrouper = ViewControllerGrouper()
    private let itemsChangedBroadcaster : Broadcaster<ConnectionStatus> = Broadcaster()
    private let sidebarController = SidebarSplitViewController(nibName : "SidebarSplitView", bundle : nil)!
    private lazy var contextBouncer : PluginContextBouncer = {
        return PluginContextBouncer(backing: self)
    }()
    
    override func awakeFromNib() {
        window?.titleVisibility = .Hidden
        window?.contentViewController = bodyController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.movableByWindowBackground = true
        
        
        deviceController.delegate = self
        deviceController.start()
        
        devicesChanged()
        bodyController.addChildViewController(sidebarController)
        
        let contentView = window?.contentView as NSView
        let sidebarView = sidebarController.view
        bodyView.addSubview(sidebarView)
        sidebarView.alphaValue = 0
        sidebarView.addConstraintsMatchingSuperviewBounds()
        
        contentView.superview!.addConstraint(NSLayoutConstraint(item: bodyView, attribute: .Top, relatedBy: .Equal, toItem: window?.contentView, attribute: .Top, multiplier: 1, constant: 0))
        
        sidebarTable?.setDelegate(viewGrouper)
        sidebarTable?.setDataSource(viewGrouper)
        sidebarController.useSidebarContent(sidebarTable!.enclosingScrollView!)
        
        sidebarTable?.registerNib(NSNib(nibNamed: "ChannelCellView", bundle: nil)!, forIdentifier: ViewControllerGrouperCellIdentifier)
        
        viewGrouper.delegate = self
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
        self.pluginController.connectedWithContext(self.contextBouncer)
    }
    
    func choseDeviceOption(sender : NSMenuItem) {
        let device = (sender.representedObject as Device?)
        deviceController.saveLastDevice(device)
        if device == nil && self.currentConnection != nil {
            self.pluginController.connectionClosed()
        }
        connectToDevice(device)
    }
    
    func showSidebarIfNecessary() {
        if currentConnection != nil && !self.emptyView.hidden {
            self.emptyView.animator().hidden = true
            self.sidebarController.view.animator().alphaValue = 1
        }
        
        if viewGrouper.hasMultipleItems {
            sidebarController.showSidebar()
        }
    }
    
    func hideSidebarIfNecessary() {
        if currentConnection == nil && self.emptyView.hidden {
            self.emptyView.animator().hidden = false
            self.sidebarController.view.animator().alphaValue = 0
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
        viewGrouper.addViewController(controller, plugin : plugin)
        showSidebarIfNecessary()
        sidebarTable.reloadData()
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        viewGrouper.removeViewController(controller, plugin : plugin)
        hideSidebarIfNecessary()
        sidebarTable.reloadData()
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

extension ConsoleWindowController : ViewControllerGrouperDelegate {
    func controllerGroupSelectedController(controller: NSViewController) {
        sidebarController.useBodyContent(controller.view)
    }
}

extension ConsoleWindowController : DeviceConnectionDelegate {
    
    func connectionClosed(connection: DeviceConnection) {
        pluginController.connectionClosed()
        currentConnection = nil;
        hideSidebarIfNecessary()
        devicesChanged()
    }
    
    func connection(connection: DeviceConnection, receivedData: NSData, channel: DLSOwnedChannel) {
        pluginController.routeMessage(receivedData, channel : channel)
    }
    
}