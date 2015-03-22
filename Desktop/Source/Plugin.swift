//
//  Plugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/13/14.
//
//

import Cocoa

protocol PluginContext : class {
    func sendMessage(data : NSData, channel: DLSChannel, plugin : Plugin)
    func addViewController(controller : NSViewController, plugin : Plugin)
    func removeViewController(controller : NSViewController, plugin : Plugin)
}

protocol Plugin {
    var name : String { get }
    var displayName : String { get }
    
    var shouldSortChildren : Bool { get }
    
    func receiveMessage(data : NSData, channel : DLSChannel)
    
    func connectedWithContext(context : PluginContext)
    func connectionClosed()
}