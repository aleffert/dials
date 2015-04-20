//
//  PluginContextBouncer.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

// Simple class to send to plugins, guaranteeing a retain cycle break
class PluginContextBouncer: NSObject, PluginContext {
    private weak var backingContext : PluginContext?
    
    init(backing : PluginContext) {
        backingContext = backing
    }
    
    func sendMessage(data : NSData, plugin : Plugin) {
        backingContext?.sendMessage(data, plugin: plugin)
    }
    
    func addViewController(controller: NSViewController, plugin: Plugin) {
        backingContext?.addViewController(controller, plugin: plugin)
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        backingContext?.removeViewController(controller, plugin: plugin)
    }

}
