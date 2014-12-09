//
//  PluginController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

protocol PluginContext : class {
    func sendMessage(data : NSData, channel: DLSChannel, plugin : Plugin)
    func addViewController(controller : NSViewController, plugin : Plugin)
    func removeViewController(controller : NSViewController, plugin : Plugin)
}

protocol Plugin {
    var name : String {get}
    var displayName : String {get}
    
    func receiveMessage(data : NSData, channel : DLSChannel)
    
    func connectedWithContext(context : PluginContext)
    func disconnected()
}

class PluginController: NSObject {
    
    private var plugins : [Plugin] = []
    
    func registerDefaultPlugins() {
        registerPlugin(LiveDialsPlugin())
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
   
}
