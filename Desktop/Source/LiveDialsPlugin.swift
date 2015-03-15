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
        let channelName = channel.name ?? "test"
        if knownChannels[channelName] == nil {
            let controller = DummyViewController(nibName: nil, bundle: nil)!
            controller.title = channelName
            context?.addViewController(controller, plugin:self)
            knownChannels[channelName] = controller
        }
        let message: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let addMessage = message as? DLSLiveDialsAddMessage {
            handleAddMessage(addMessage)
        }
        else if let removeMessage = message as? DLSLiveDialsRemoveMessage {
            handleRemoveMessage(removeMessage)
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
    
    func handleAddMessage(message : DLSLiveDialsAddMessage) {
        println("add message");
    }
    
    func handleRemoveMessage(message : DLSLiveDialsRemoveMessage) {
        println("remove message");
    }
}
