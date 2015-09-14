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
    
    private func registerPluginsFromURLs(urls : [NSURL]) {
        for url in urls {
            if let bundle = NSBundle(URL: url),
                loaded = bundle.load() as Bool?,
                pluginClass = bundle.principalClass as? NSObject.Type,
                plugin = pluginClass.init() as? Plugin where loaded {
                    registerPlugin(plugin)
                    print("Loaded plugin: \(url.lastPathComponent)")
            }
            else {
                print("Failed to load plugin: \(url.lastPathComponent)")
            }
        }
    }
    
    private func registerBundlePlugins() {
        let urls = NSBundle.mainBundle().URLsForResourcesWithExtension(PluginPathExtension, subdirectory: "PlugIns") ?? []
        registerPluginsFromURLs(urls)
    }
    
    // We also pick up any plugins side by side with the app so that build products
    // are easy to pick up
    private func registerAdjacentPlugins() {
        let bundleURL = NSBundle.mainBundle().bundleURL
        if let adjacentPaths = NSFileManager.defaultManager().enumeratorAtURL(bundleURL, includingPropertiesForKeys: nil, options: [], errorHandler: nil) { // NSFileManager.defaultManager().enumeratorAtPath(bundlePath.URLByDeletingLastPathComponent)?.allObjects as? [String] {
            let urls = adjacentPaths.filter {
                $0.pathExtension == PluginPathExtension
            } as? [NSURL] ?? []
            registerPluginsFromURLs(urls)
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
