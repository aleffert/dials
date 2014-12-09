//
//  LiveDialsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class LiveDialsPlugin: NSObject, Plugin {
    
    var name : String = "com.akivaleffert.live-dials"

    var displayName : String = "Control Panel"
    
    var knownChannels : [String:NSViewController] = [:]
    var context : PluginContext?
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        if knownChannels[channel.name] == nil {
            let controller = NSViewController(nibName: nil, bundle: nil)!
            context?.addViewController(controller, plugin:self)
        }
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func disconnected() {
        for (name, controller) in knownChannels {
            context?.removeViewController(controller, plugin: self)
        }
        knownChannels = [:]
    }
}
