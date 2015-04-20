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
    
    private var knownGroups : [String:LiveDialPaneViewController] = [:]
    private var context : PluginContext?
    
    var shouldSortChildren : Bool {
        return true
    }
    
    func receiveMessage(data: NSData) {
        let message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? DLSLiveDialsMessage
        
        if let group = message?.group {
            if knownGroups[group] == nil {
                let controller = LiveDialPaneViewController(group : group, delegate : self)!
                context?.addViewController(controller, plugin:self)
                knownGroups[group] = controller
            }
        }
        
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
        for (name, controller) in knownGroups {
            context?.removeViewController(controller, plugin: self)
        }
        knownGroups = [:]
    }
    
    func handleAddMessage(message : DLSLiveDialsAddMessage) {
        let controller = knownGroups[message.group]
        controller?.addDial(message.dial)
    }
    
    func handleRemoveMessage(message : DLSLiveDialsRemoveMessage) {
        let controller = knownGroups[message.group]
        if let c = controller {
            c.removeDialWithID(message.uuid)
            if c.isEmpty {
                self.context?.removeViewController(c, plugin: self)
                knownGroups.removeValueForKey(message.group)
            }
        }
    }
    
    func paneController(controller: LiveDialPaneViewController, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        var message = DLSLiveDialsChangeMessage(UUID: dial.uuid, value: value, group : controller.group as String)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
    
    func paneController(controller: LiveDialPaneViewController, shouldSaveDial dial: DLSLiveDial, withValue value: NSCoding?) {
        let codeManager = CodeManager()
        let symbol = codeManager.findSymbolWithName(dial.displayName, inFile:dial.file!)
        symbol.bind {
            codeManager.updateSymbol($0, toValue: value, withEditor:dial.editor, inFile:dial.file!)
        }
    }
}
