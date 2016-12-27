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
    
    fileprivate var knownGroups : [String:ControlListPaneViewController] = [:]
    fileprivate var context : PluginContext?
    
    var shouldSortChildren : Bool {
        return true
    }
    
    func receiveMessage(_ data: Data) {
        let message = NSKeyedUnarchiver.unarchiveObject(with: data) as? DLSControlPanelMessage
        
        if let group = message?.group {
            if knownGroups[group] == nil {
                let controller = ControlListPaneViewController(group : group, delegate : self)!
                context?.add(controller, plugin:self)
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
    
    func connected(with context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        for (_, controller) in knownGroups {
            context?.remove(controller, plugin: self)
        }
        knownGroups = [:]
    }
    
    func handleAddMessage(_ message : DLSControlPanelAddMessage) {
        let controller = knownGroups[message.group]
        controller?.addControlWithInfo(message.info)
    }
    
    func handleRemoveMessage(_ message : DLSControlPanelRemoveMessage) {
        let controller = knownGroups[message.group]
        if let c = controller {
            c.removeControlWithID(message.uuid)
            if c.isEmpty {
                self.context?.remove(c, plugin: self)
                knownGroups.removeValue(forKey: message.group)
            }
        }
    }
    
    func paneController(_ controller: ControlListPaneViewController, changedControlInfo info: DLSControlInfo, toValue value: NSCoding?) {
        let message = DLSControlPanelChangeMessage(uuid: info.uuid, value: value, group : controller.group as String)
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        context?.sendMessage(data, plugin: self)
    }
    
    fileprivate func showCodeUpdateError(_ message : String) {
        let alert = NSAlert()
        alert.messageText = "Error Updating Code"
        alert.informativeText = message
        alert.addButton(withTitle: "Okay")
        alert.runModal()
    }
    
    func paneController(_ controller: ControlListPaneViewController, shouldSaveControlInfo info: DLSControlInfo, withValue value: NSCoding?) {
        do {
            guard let file = info.file else {
                throw CodeError.internalError
            }
            guard let codeManager = codeHelper as? CodeManager else {
                throw CodeError.internalError
            }
            let url = URL(fileURLWithPath: file)
            let symbol = try codeManager.findSymbolWithName(info.label, inFileAtURL:url)
            try codeManager.updateSymbol(symbol, toValue: value, with:info.editor, at:url)
        }
        catch let e as NSError {
            showCodeUpdateError(e.localizedDescription)
        }
        catch let e as CodeError {
            showCodeUpdateError(e.message)
        }
        
    }
}
