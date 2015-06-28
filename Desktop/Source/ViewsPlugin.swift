//
//  ViewsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

class ViewsPlugin: NSObject, Plugin, ViewsViewControllerDelegate {
    
    var controller : ViewsViewController?
    var context : PluginContext?
    
    override init() {
        super.init()
    }
    
    let identifier = DLSViewsPluginIdentifier
    
    let label = "Views"
    
    let shouldSortChildren = true
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
        let controller = ViewsViewController(nibName: "ViewsViewController", bundle: nil)!
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
        if let m = message as? DLSViewsFullHierarchyMessage {
            handleFullHierarchyMessage(m)
        }
        else if let m = message as? DLSViewsViewPropertiesMessage {
            handleViewPropertiesMessage(m)
        }
        else if let m = message as? DLSViewsUpdatedViewsMessage {
            handleUpdatedViewsMessage(m)
        }
        else if let m = message as? DLSViewsUpdatedContentsMessage {
            handleUpdatedContentsMessage(m)
        }
        else {
            assertionFailure("Unknown message type: \(message)")
        }
    }

    func handleFullHierarchyMessage(message : DLSViewsFullHierarchyMessage) {
        let hierarchy = message.hierarchy as! [NSString:DLSViewHierarchyRecord]
        let roots = message.roots as! [NSString]
        controller?.receivedHierarchy(hierarchy, roots : roots, screenSize : message.screenSize)
    }
    
    func handleViewPropertiesMessage(message : DLSViewsViewPropertiesMessage) {
        controller?.receivedViewRecord(message.record)
    }
    
    func handleUpdatedViewsMessage(message : DLSViewsUpdatedViewsMessage) {
        controller?.receivedUpdatedViews(message.records as! [DLSViewHierarchyRecord], roots: message.roots as! [NSString], screenSize : message.screenSize)
    }
    
    func handleUpdatedContentsMessage(message : DLSViewsUpdatedContentsMessage) {
        controller?.receivedContents(message.contents as! [NSString:NSData], empties : message.empties as! [NSString])
    }
    
    //MARK: ViewsViewControllerDelegate
    
    func viewsController(controller: ViewsViewController, selectedViewWithID viewID: NSString?) {
        let message = DLSViewsSelectViewMessage(viewID: viewID as String?)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
    
    func viewsController(controller: ViewsViewController, valueChangedWithRecord record: DLSChangeViewValueRecord) {
        let message = DLSViewsValueChangedMessage(record : record)
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        context?.sendMessage(data, plugin: self)
    }
}