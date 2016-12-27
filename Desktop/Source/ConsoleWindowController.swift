//
//  ConsoleWindowController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

private let LastKnownDeviceKey = "DLSLastKnownDeviceKey"

class ConsoleWindowController: NSWindowController {
    
    @IBOutlet fileprivate var emptyView : NSView!
    @IBOutlet fileprivate var bodyView : NSView!
    @IBOutlet fileprivate var sidebarTable : NSTableView!
    
    @IBOutlet fileprivate var bodyController : NSViewController!
    
    
    fileprivate let deviceController : DeviceController = DeviceController()
    fileprivate var currentConnection : DeviceConnection?
    
    fileprivate let pluginController : PluginController = PluginController()
    fileprivate let viewGrouper : ViewControllerGrouper = ViewControllerGrouper()
    fileprivate let itemsChangedBroadcaster : Broadcaster<ConnectionStatus> = Broadcaster()
    fileprivate let sidebarController = SidebarSplitViewController(nibName : nil, bundle : nil)!
    fileprivate lazy var contextBouncer : PluginContextBouncer = {
        return PluginContextBouncer(backing: self)
    }()
    
    override func awakeFromNib() {
        window?.titleVisibility = .hidden
        window?.contentViewController = bodyController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.isMovableByWindowBackground = true
        
        
        deviceController.delegate = self
        deviceController.start()
        
        devicesChanged()
        bodyController.addChildViewController(sidebarController)
        
        let contentView = window?.contentView
        let sidebarView = sidebarController.view
        bodyView.addSubview(sidebarView)
        sidebarView.alphaValue = 0
        sidebarView.addConstraintsMatchingSuperviewBounds()
        
        contentView?.superview?.addConstraint(NSLayoutConstraint(item: bodyView, attribute: .top, relatedBy: .equal, toItem: window?.contentView, attribute: .top, multiplier: 1, constant: 0))
        
        sidebarTable?.delegate = viewGrouper
        sidebarTable?.dataSource = viewGrouper
        sidebarTable?.floatsGroupRows = false
        sidebarController.useSidebarContent(sidebarTable!.enclosingScrollView!)
        
        sidebarTable?.register(NSNib(nibNamed: "ChannelCellView", bundle: nil)!, forIdentifier: ViewControllerGrouperCellIdentifier)
        
        viewGrouper.delegate = self
    }
    
    fileprivate func lastKnownConnection() -> String? {
        return UserDefaults.standard.object(forKey: LastKnownDeviceKey) as? String
    }
    
    fileprivate func saveLastKnownConnection(_ connection : String) {
        UserDefaults.standard.set(connection, forKey: LastKnownDeviceKey)
    }
    
    fileprivate func devicesChanged() {
        if let device = currentConnection?.device {
            itemsChangedBroadcaster.notifyListeners(.active(current : device, all : deviceController.knownDevices))
        }
        else if deviceController.hasDevices {
            itemsChangedBroadcaster.notifyListeners(.available(deviceController.knownDevices))
            if let lastKnown = lastKnownConnection() {
                for device in deviceController.knownDevices {
                    if device.label == lastKnown {
                        connectToDevice(device)
                        break
                    }
                }
            }
        }
        else {
            itemsChangedBroadcaster.notifyListeners(.none)
        }
    }
    
    func connectToDevice(_ device : Device?) {
        currentConnection?.close()
        currentConnection = device?.openConnection(delegate : self)
        showSidebarIfNecessary()
        hideSidebarIfNecessary()
        devicesChanged()
        if device != nil {
            self.pluginController.connectedWithContext(self.contextBouncer)
        }
        device.bind { self.saveLastKnownConnection($0.label) }
    }
    
    func choseDeviceOption(_ sender : NSMenuItem) {
        let device = (sender.representedObject as! Device?)
        deviceController.saveLastDevice(device)
        if device == nil && self.currentConnection != nil {
            self.pluginController.connectionClosed()
            self.saveLastKnownConnection("")
        }
        connectToDevice(device)
    }
    
    func showSidebarIfNecessary() {
        if currentConnection != nil && !self.emptyView.isHidden {
            self.emptyView.animator().isHidden = true
            self.sidebarController.view.animator().alphaValue = 1
        }
        
        if viewGrouper.hasMultipleItems {
            sidebarController.showSidebar()
        }
    }
    
    func hideSidebarIfNecessary() {
        if currentConnection == nil && self.emptyView.isHidden {
            self.emptyView.animator().isHidden = false
            self.sidebarController.view.animator().alphaValue = 0
        }
        
        if !viewGrouper.hasMultipleItems {
            sidebarController.hideSidebar()
        }
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(ConsoleWindowController.showPreviousTab(_:)) || menuItem.action == #selector(ConsoleWindowController.showNextTab(_:)) {
            return self.viewGrouper.hasMultipleItems
        }
        else if menuItem.action == #selector(ConsoleWindowController.toggleSidebar(_:)) {
            if sidebarController.isSidebarVisible {
                menuItem.title = "Hide Sidebar"
            }
            else {
                menuItem.title = "Show Sidebar"
            }
            return self.viewGrouper.hasMultipleItems
        }
        return true
    }
    
    func toggleSidebar(_ sender : AnyObject) {
        sidebarController.toggleSidebar()
    }
    
    func showPreviousTab(_ sender : NSMenuItem) {
        let index = viewGrouper.previousTabIndex(sidebarTable.selectedRow)
        sidebarTable.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }
    
    func showNextTab(_ sender : NSMenuItem) {
        let index = viewGrouper.nextTabIndex(sidebarTable.selectedRow)
        sidebarTable.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }
}

extension ConsoleWindowController : NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return [NSToolbarFlexibleSpaceItemIdentifier, ConnectionStatusToolbarItemIdentifier]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return [NSToolbarFlexibleSpaceItemIdentifier, ConnectionStatusToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == ConnectionStatusToolbarItemIdentifier {
            return ConnectionStatusToolbarItem(changeBroadcaster: itemsChangedBroadcaster)
        }
        else {
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
}

extension ConsoleWindowController : PluginContext {
    
    fileprivate func updateControllersWithAction(_ action : () -> ()) {
        let currentIndexes = sidebarTable.selectedRowIndexes;
        let currentSelection = viewGrouper.controllersForRowIndexes(currentIndexes)
        
        action()
        
        let newSelection = viewGrouper.rowIndexesForControllers(currentSelection)
        sidebarTable.reloadData()
        if currentIndexes.count > 0 {
            sidebarTable.selectRowIndexes(newSelection, byExtendingSelection: false)
        }
    }
    
    func add(_ controller: NSViewController, plugin: Plugin) {
        // Load the view now since having unloaded views makes the model simpler
        let _ = controller.view
        if let owner = controller as? ConstraintInfoOwner {
            owner.constraintInfoSource = pluginController
        }
        
        updateControllersWithAction {
            self.viewGrouper.addViewController(controller, plugin : plugin)
        }
        showSidebarIfNecessary()
    }
    
    func remove(_ controller: NSViewController, plugin: Plugin) {
        updateControllersWithAction {
            self.viewGrouper.removeViewController(controller, plugin : plugin)
        }
        
        hideSidebarIfNecessary()
    }
    
    func sendMessage(_ data: Data, plugin: Plugin) {
        let channel = DLSChannel(name : plugin.identifier)
        self.currentConnection?.sendMessage(data, channel: channel)
    }
}

extension ConsoleWindowController : DeviceControllerDelegate {
    
    func deviceControllerUpdatedDevices(_ controller: DeviceController) {
        devicesChanged()
    }
    
}

extension ConsoleWindowController : ViewControllerGrouperDelegate {
    func controllerGroupSelectedController(_ controller: NSViewController) {
        sidebarController.useBodyContent(controller.view)
    }
}

extension ConsoleWindowController : DeviceConnectionDelegate {
    
    func connectionClosed(_ connection: DeviceConnection) {
        pluginController.connectionClosed()
        currentConnection = nil;
        hideSidebarIfNecessary()
        devicesChanged()
    }
    
    func connection(_ connection: DeviceConnection, receivedData: Data, channel: DLSChannel) {
        pluginController.routeMessage(receivedData, channel : channel)
    }
    
}
