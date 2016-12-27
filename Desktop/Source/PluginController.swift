//
//  PluginController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

private let PluginPathExtension = "dialsplugin"

protocol ConstraintInfoSource : class {
    var constraintSources : [ConstraintPlugin] { get }
}

protocol ConstraintInfoOwner : class {
    weak var constraintInfoSource : ConstraintInfoSource? { get set }
}

class PluginController: NSObject, ConstraintInfoSource {
    
    fileprivate var plugins : [Plugin] = []
    fileprivate let codeManager = CodeManager()
    
    override init() {
        super.init()
        self.registerDefaultPlugins()
        self.registerBundlePlugins()
        self.registerAdjacentPlugins()
    }
    
    var constraintSources : [ConstraintPlugin] {
        return self.plugins.flatMap {
            return $0 as? ConstraintPlugin
        }
    }
    
    fileprivate func registerDefaultPlugins() {
        registerPlugin(ControlPanelPlugin())
        registerPlugin(ViewsPlugin())
        registerPlugin(NetworkRequestsPlugin())
    }
    
    fileprivate func registerPluginsFromURLs(_ urls : [URL]) {
        for url in urls {
            let fileName = url.lastPathComponent 
            if let bundle = Bundle(url: url), let loaded = bundle.load() as Bool?, loaded {
                print("Loaded plugin named: \(fileName)")
                if let
                    pluginClass = bundle.principalClass as? NSObject.Type,
                    let plugin = pluginClass.init() as? Plugin {
                        registerPlugin(plugin)
                        print("Registered plugin class: \(pluginClass)")
                        if let owner = plugin as? CodeHelperOwner {
                            owner.codeHelper = codeManager
                        }
                }
            }
            else {
                print("Failed to load plugin: \(url.lastPathComponent)")
            }
        }
    }
    
    fileprivate func registerBundlePlugins() {
        let urls = Bundle.main.urls(forResourcesWithExtension: PluginPathExtension, subdirectory: "PlugIns") ?? []
        registerPluginsFromURLs(urls)
    }
    
    // We also pick up any plugins side by side with the app so that build products
    // are easy to pick up
    fileprivate func registerAdjacentPlugins() {
        let bundleURL = Bundle.main.bundleURL
        let searchURL = bundleURL.deletingLastPathComponent()
        
        if let adjacentPaths = FileManager.default.enumerator(at: searchURL, includingPropertiesForKeys: nil, options: [], errorHandler: nil) {
            let urls = adjacentPaths.filter {
                ($0 as! URL).pathExtension == PluginPathExtension
            } as? [URL] ?? []
            registerPluginsFromURLs(urls)
        }
    }
    
    fileprivate func registerPlugin(_ plugin : Plugin) {
        plugins.append(plugin)
    }
    
    fileprivate func pluginWithIdentifier(_ identifier : String) -> Plugin? {
        for possible in plugins {
            if possible.identifier == identifier {
                return possible
            }
        }
        return nil
    }
    
    func routeMessage(_ data : Data, channel : DLSChannel) {
        let plugin = pluginWithIdentifier(channel.name)
        plugin?.receiveMessage(data)
    }
    
    func connectionClosed() {
        for plugin in plugins {
            plugin.connectionClosed()
        }
    }
    
    func connectedWithContext(_ context : PluginContext) {
        for plugin in plugins {
            plugin.connected(with: context)
        }
    }

}
