//
//  LiveDialsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class DummyViewController : NSViewController {
    override func loadView() {
        self.view = NSView(frame: CGRectZero)
    }
}

class LiveDialsPlugin: NSObject, Plugin {
    
    var name : String = "com.akivaleffert.live-dials"

    var displayName : String = "Control Panel"
    
    private var knownChannels : [String:NSViewController] = [:]
    private var context : PluginContext?
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        if knownChannels[channel.name] == nil {
            let controller = DummyViewController(nibName: nil, bundle: nil)!
            controller.title = channel.name
            context?.addViewController(controller, plugin:self)
            knownChannels[channel.name] = controller
        }
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        for (name, controller) in knownChannels {
            context?.removeViewController(controller, plugin: self)
        }
        knownChannels = [:]
    }
}
