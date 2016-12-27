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
    fileprivate weak var backingContext : PluginContext?
    
    init(backing : PluginContext) {
        backingContext = backing
    }
    
    func sendMessage(_ data : Data, plugin : Plugin) {
        backingContext?.sendMessage(data, plugin: plugin)
    }
    
    func add(_ controller: NSViewController, plugin: Plugin) {
        backingContext?.add(controller, plugin: plugin)
    }
    
    func remove(_ controller: NSViewController, plugin: Plugin) {
        backingContext?.remove(controller, plugin: plugin)
    }

}
