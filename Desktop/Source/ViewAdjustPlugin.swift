//
//  ViewAdjustPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

class ViewAdjustPlugin: Plugin {
    
    var controller : ViewAdjustViewController?
    var context : PluginContext?
    
    init() {
        
    }
    
    var name : String {
        return DLSViewAdjustPluginName
    }
    
    var shouldSortChildren : Bool {
        return true
    }
    
    var displayName : String {
        return "Views"
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
        let controller = ViewAdjustViewController(nibName: "ViewAdjustViewController", bundle: nil)!
        self.controller = controller
        self.context?.addViewController(controller, plugin: self)
    }
    
    func connectionClosed() {
        controller.bind { self.context?.removeViewController($0, plugin: self) }
        context = nil
        controller = nil
    }
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        let message: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let hierarchyMessage = message as? DLSViewAdjustFullHierarchyMessage {
            controller?.receivedHierarchy(hierarchyMessage.hierarchy)
        }
        else {
            assertionFailure("Unknown message type: \(message)")
        }
    }
}
