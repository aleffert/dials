//
//  PluginController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class TestPlugin : Plugin {
    var context : PluginContext?
    var controller : NSViewController?
    
    var name : String {
        return "Test"
    }
    
    var displayName : String {
        return "Test Plugin"
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        context?.removeViewController(controller!, plugin: self)
    }
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        controller = NSViewController(nibName: nil, bundle: nil)!
        controller?.view = NSView(frame: NSMakeRect(0, 0, 100, 100))
        context?.addViewController(controller!, plugin: self)
    }
    
    var shouldSortChildren : Bool {
        return false
    }
}

class PluginController: NSObject {
    
    private var plugins : [Plugin] = []
    
    override init() {
        super.init()
        self.registerDefaultPlugins()
    }
    
    func registerDefaultPlugins() {
        registerPlugin(LiveDialsPlugin())
        registerPlugin(TestPlugin())
    }
    
    func registerPlugin(plugin : Plugin) {
        plugins.append(plugin)
    }
    
    private func pluginWithName(name : String) -> Plugin? {
        for possible in plugins {
            if possible.name == name {
                return possible
            }
        }
        return nil
    }
    
    func routeMessage(data : NSData, channel : DLSOwnedChannel) {
        let plugin = pluginWithName(channel.owner)
        plugin?.receiveMessage(data, channel: channel)
    }
    
    func connectionClosed() {
        for plugin in plugins {
            plugin.connectionClosed()
        }
    }
    
    func connectedWithContext(context : PluginContext) {
        for plugin in plugins {
            plugin.connectedWithContext(context)
        }
    }

}
