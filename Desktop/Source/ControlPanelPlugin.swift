//
//  ControlPanelPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class ControlPanelPlugin: NSObject, Plugin, ControlListPaneViewControllerDelegate {
    
    let identifier = DLSControlPanelPluginIdentifier

    let label = "Control Panel"
    
    private var knownGroups : [String:ControlListPaneViewController] = [:]
    private var context : PluginContext?
    
    var shouldSortChildren : Bool {
        return true
    }
    
    func receiveMessage(data: NSData) {
        let message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? DLSControlPanelMessage
        
        if let group = message?.group {
            if knownGroups[group] == nil {
                let controller = ControlListPaneViewController(group : group, delegate : self)!
                context?.addViewController(controller, plugin:self)
                knownGroups[group] = controller
            }
        }
        
        if let addMessage = message as? DLSControlPanelAddMessage {
            handleAddMessage(addMessage)
        }
        else if let removeMessage = message as? DLSControlPanelRemoveMessage {
            handleRemoveMessage(removeMessage)
        }
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        for (_, controller) in knownGroups {
            context?.removeViewController(controller, plugin: self)
        }
        knownGroups = [:]
    }
    
    func handleAddMessage(message : DLSControlPanelAddMessage) {
        let controller = knownGroups[message.group]
        controller?.addControlWithInfo(message.info)
    }
    
    func handleRemoveMessage(message : DLSControlPanelRemoveMessage) {
        let controller = knownGroups[message.group]
        if let c = controller {
            c.removeControlWithID(message.uuid)
            if c.isEmpty {
                self.context?.removeViewController(c, plugin: self)
                knownGroups.removeValueForKey(message.group)
            }
        }
    }
    
    func paneController(controller: ControlListPaneViewController, changedControlInfo info: DLSControlInfo, toValue value: NSCoding?) {
        let message = DLSControlPanelChangeMessage(UUID: info.uuid, value: value, group : controller.group as String)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
    
    func paneController(controller: ControlListPaneViewController, shouldSaveControlInfo info: DLSControlInfo, withValue value: NSCoding?) {
        let codeManager = CodeManager()
        let file = info.file.toResult("Internal Error: Trying to save when file not present")
        file.bind {file -> Result<()> in
            let url = NSURL(fileURLWithPath: file)
            let symbol = codeManager.findSymbolWithName(info.label, inFileAtURL:url)
            return symbol.bind {symbol in
                codeManager.updateSymbol(symbol, toValue: value, withEditor:info.editor, atURL:url)
            }
        }.ifFailure {message in
            let alert = NSAlert()
            alert.messageText = "Error Updating Code"
            alert.informativeText = message
            alert.addButtonWithTitle("Okay")
            alert.runModal()
        }
    }
}
