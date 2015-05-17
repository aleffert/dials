//
//  Plugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/13/14.
//
//

import Cocoa

/// Communication interface between plugin and host app
protocol PluginContext : class {
    
    /// Send a message to iOS
    ///
    /// :param: data the data to send
    /// :param: plugin The sending plugin
    func sendMessage(data : NSData, plugin : Plugin)
    
    /// Call this to add a new view controller. The `title` property of the controller
    /// Is used for display.
    ///
    /// :param: controller The controller to add.
    /// :param: plugin The sending plugin.
    func addViewController(controller : NSViewController, plugin : Plugin)
    
    /// Remove a controller from the sidebar.
    ///
    /// :param: controller The controller to add.
    /// :param: plugin The sending plugin.
    func removeViewController(controller : NSViewController, plugin : Plugin)
}

/// Plugins should implement this interface
protocol Plugin {
    
    /// Unique identifier for the plugin. Should match the corresponding iOS side plugin.
    var name : String { get }
    
    /// User facing name of the plugin.
    var displayName : String { get }
    
    /// Whether view controller children in the sidebar are sorted alphabetically.
    /// If false, they will be sorted by the order in which they were added
    var shouldSortChildren : Bool { get }
    
    /// Called when a message is received from the corresponding iOS plugin
    /// :param: data The message received
    func receiveMessage(data : NSData)
    
    /// Called when a connection to a device is opened
    ///
    /// :param: context The communication channel between the plugin and its host
    func connectedWithContext(context : PluginContext)
    
    /// Called when a connection to a device is closed.
    /// After this call, the original context is no longer valid
    func connectionClosed()
}