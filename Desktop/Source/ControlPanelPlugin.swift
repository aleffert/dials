//
//  ControlPanelPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class ControlPanelPlugin: NSObject, Plugin, CodeHelperOwner, ControlListPaneViewControllerDelegate {
    
    var codeHelper: CodeHelper?
    
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
    
    private func showCodeUpdateError(message : String) {
        let alert = NSAlert()
        alert.messageText = "Error Updating Code"
        alert.informativeText = message
        alert.addButtonWithTitle("Okay")
        alert.runModal()
    }
    
    func paneController(controller: ControlListPaneViewController, shouldSaveControlInfo info: DLSControlInfo, withValue value: NSCoding?) {
        do {
            guard let file = info.file else {
                throw CodeError.InternalError
            }
            guard let codeManager = codeHelper as? CodeManager else {
                throw CodeError.InternalError
            }
            let url = NSURL(fileURLWithPath: file)
            let symbol = try codeManager.findSymbolWithName(info.label, inFileAtURL:url)
            try codeManager.updateSymbol(symbol, toValue: value, withEditor:info.editor, atURL:url)
        }
        catch let e as NSError {
            showCodeUpdateError(e.localizedDescription)
        }
        catch let e as CodeError {
            showCodeUpdateError(e.message)
        }
        
    }
}
