//
//  LiveDialsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class LiveDialsPlugin: NSObject, Plugin, LiveDialPaneViewControllerDelegate {
    
    var name : String = DLSLiveDialsPluginName

    var displayName : String = "Control Panel"
    
    private var knownChannels : [String:LiveDialPaneViewController] = [:]
    private var context : PluginContext?
    
    var shouldSortChildren : Bool {
        return true
    }
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        if knownChannels[channel.name] == nil {
            let controller = LiveDialPaneViewController(channel : channel, delegate : self)!
            context?.addViewController(controller, plugin:self)
            knownChannels[channel.name] = controller
        }
        let message: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let addMessage = message as? DLSLiveDialsAddMessage {
            handleAddMessage(addMessage, channel: channel.name)
        }
        else if let removeMessage = message as? DLSLiveDialsRemoveMessage {
            handleRemoveMessage(removeMessage, channel : channel.name)
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
    
    func handleAddMessage(message : DLSLiveDialsAddMessage, channel: String) {
        let controller = knownChannels[channel]
        controller?.addDial(message.dial)
    }
    
    func handleRemoveMessage(message : DLSLiveDialsRemoveMessage, channel : String) {
        let controller = knownChannels[channel]
        controller?.removeDialWithID(message.uuid)
        println("remove message");
    }
    
    func paneController(controller: LiveDialPaneViewController, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        var message = DLSLiveDialsChangeMessage(UUID: dial.uuid, value: value)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, channel: controller.channel, plugin: self)
    }
    
    func paneController(controller: LiveDialPaneViewController, shouldSaveDial dial: DLSLiveDial, withValue value: NSCoding?) {
        let codeManager = CodeManager()
        let symbol = codeManager.findSymbolWithName(dial.displayName, inFile:dial.file)
        symbol.bind {
            codeManager.updateSymbol($0, toValue: value, withEditor:dial.editor!, inFile:dial.file)
        }
    }
}
