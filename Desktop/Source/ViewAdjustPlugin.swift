//
//  ViewAdjustPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

class ViewAdjustPlugin: Plugin, ViewAdjustViewControllerDelegate {
    
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
        controller.delegate = self
        self.controller = controller
        self.context?.addViewController(controller, plugin: self)
    }
    
    func connectionClosed() {
        controller.bind { self.context?.removeViewController($0, plugin: self) }
        context = nil
        controller = nil
    }
    
    func receiveMessage(data: NSData) {
        let message : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let m = message as? DLSViewAdjustFullHierarchyMessage {
            handleFullHierarchyMessage(m)
        }
        else if let m = message as? DLSViewAdjustViewPropertiesMessage {
            handleViewPropertiesMessage(m)
        }
        else if let m = message as? DLSViewAdjustUpdatedViewsMessage {
            handleUpdatedViewsMessage(m)
        }
        else if let m = message as? DLSViewAdjustUpdatedContentsMessage {
            handleUpdatedContentsMessage(m)
        }
        else {
            assertionFailure("Unknown message type: \(message)")
        }
    }

    func handleFullHierarchyMessage(message : DLSViewAdjustFullHierarchyMessage) {
        let hierarchy = message.hierarchy as! [NSString:DLSViewHierarchyRecord]
        let roots = message.roots as! [NSString]
        controller?.receivedHierarchy(hierarchy, roots : roots, screenSize : message.screenSize)
    }
    
    func handleViewPropertiesMessage(message : DLSViewAdjustViewPropertiesMessage) {
        controller?.receivedViewRecord(message.record)
    }
    
    func handleUpdatedViewsMessage(message : DLSViewAdjustUpdatedViewsMessage) {
        controller?.receivedUpdatedViews(message.records as! [DLSViewHierarchyRecord], roots: message.roots as! [NSString], screenSize : message.screenSize)
    }
    
    func handleUpdatedContentsMessage(message : DLSViewAdjustUpdatedContentsMessage) {
        controller?.receivedContents(message.contents as! [NSString:NSData], empties : message.empties as! [NSString])
    }
    
    //MARK: ViewAdjustViewControllerDelegate
    
    func viewAdjustController(controller: ViewAdjustViewController, selectedViewWithID viewID: NSString?) {
        let message = DLSViewAdjustSelectViewMessage(viewID: viewID as String?)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
    
    func viewAdjustController(controller: ViewAdjustViewController, valueChangedWithRecord record: DLSChangeViewValueRecord) {
        let message = DLSViewAdjustValueChangedMessage(record : record)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
}
