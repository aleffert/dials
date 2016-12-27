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
    
    func connected(with context: PluginContext) {
        self.context = context
        let controller = ViewsViewController(nibName: "ViewsViewController", bundle: nil)!
        controller.delegate = self
        self.controller = controller
        self.context?.add(controller, plugin: self)
    }
    
    func connectionClosed() {
        controller.bind { self.context?.remove($0, plugin: self) }
        context = nil
        controller = nil
    }
    
    func receiveMessage(_ data: Data) {
        let message : AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
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

    func handleFullHierarchyMessage(_ message : DLSViewsFullHierarchyMessage) {
        let hierarchy = message.hierarchy
        let roots = message.roots
        controller?.receivedHierarchy(hierarchy, roots : roots, screenSize : message.screenSize)
    }
    
    func handleViewPropertiesMessage(_ message : DLSViewsViewPropertiesMessage) {
        controller?.receivedViewRecord(message.record)
    }
    
    func handleUpdatedViewsMessage(_ message : DLSViewsUpdatedViewsMessage) {
        controller?.receivedUpdatedViews(message.records, roots: message.roots, screenSize : message.screenSize)
    }
    
    func handleUpdatedContentsMessage(_ message : DLSViewsUpdatedContentsMessage) {
        controller?.receivedContents(message.contents, empties : message.empties)
    }
    
    //MARK: ViewsViewControllerDelegate
    
    func viewsController(_ controller: ViewsViewController, selectedViewWithID viewID: String?) {
        let message = DLSViewsSelectViewMessage(viewID: viewID as String?)
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        context?.sendMessage(data, plugin: self)
    }
    
    func viewsController(_ controller: ViewsViewController, valueChangedWithRecord record: DLSChangeViewValueRecord) {
        let message = DLSViewsValueChangedMessage(record : record)
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        context?.sendMessage(data, plugin: self)
    }
    
    func viewController(_ controller: ViewsViewController, appliedInsets insets: EdgeInsets, toViewWithID viewID: String) {
        let message = DLSViewsInsetViewMessage(viewID: viewID, insets: DLSWrapNSEdgeInsets(insets))
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        context?.sendMessage(data, plugin: self)
    }
}
