//
//  PluginController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class PluginController: NSObject {
    
    private var plugins : [Plugin] = []
    
    override init() {
        super.init()
        self.registerDefaultPlugins()
    }
    
    func registerDefaultPlugins() {
        registerPlugin(LiveDialsPlugin())
        registerPlugin(ViewAdjustPlugin())
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
