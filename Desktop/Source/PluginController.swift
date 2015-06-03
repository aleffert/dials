//
//  PluginController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

private let PluginPathExtension = "dialsplugin"

class PluginController: NSObject {
    
    private var plugins : [Plugin] = []
    
    override init() {
        super.init()
        self.registerDefaultPlugins()
        self.registerBundlePlugins()
        self.registerAdjacentPlugins()
    }
    
    private func registerDefaultPlugins() {
        registerPlugin(ControlPanelPlugin())
        registerPlugin(ViewsPlugin())
        registerPlugin(NetworkRequestsPlugin())
    }
    
    private func registerPluginsFromPaths(paths : [String]) {
        for path in paths {
            if let bundle = NSBundle(path: path as String),
                loaded = bundle.load() as Bool?,
                pluginClass = bundle.principalClass as? NSObject.Type,
                plugin = pluginClass() as? Plugin where loaded {
                    registerPlugin(plugin)
                    println("Loaded plugin: \(path.lastPathComponent)")
            }
            else {
                println("Failed to load plugin: \(path.lastPathComponent)")
            }
        }
    }
    
    private func registerBundlePlugins() {
        let paths = NSBundle.mainBundle().pathsForResourcesOfType(PluginPathExtension, inDirectory: "PlugIns") as? [String] ?? []
        registerPluginsFromPaths(paths)
    }
    
    // We also pick up any plugins side by side with the app so that build products
    // are easy to pick up
    private func registerAdjacentPlugins() {
        let bundlePath = NSBundle.mainBundle().bundlePath
        if let adjacentPaths = NSFileManager.defaultManager().enumeratorAtPath(bundlePath.stringByDeletingLastPathComponent)?.allObjects as? [String] {
            let paths = adjacentPaths.filter {
                $0.pathExtension == PluginPathExtension
            }
            registerPluginsFromPaths(paths)
        }
    }
    
    private func registerPlugin(plugin : Plugin) {
        plugins.append(plugin)
    }
    
    private func pluginWithIdentifier(identifier : String) -> Plugin? {
        for possible in plugins {
            if possible.identifier == identifier {
                return possible
            }
        }
        return nil
    }
    
    func routeMessage(data : NSData, channel : DLSChannel) {
        let plugin = pluginWithIdentifier(channel.name)
        plugin?.receiveMessage(data)
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
