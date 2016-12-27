//
//  NetworkPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/2/15.
//
//

import Cocoa

class NetworkRequestsPlugin: NSObject, Plugin {
    
    var context : PluginContext?
    var controller : NetworkRequestsViewController?
    
    let identifier = DLSNetworkRequestsPluginIdentifier
    
    let label = "Network"
    
    let shouldSortChildren = true
    
    func connected(with context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        if let controller = controller {
            self.context?.remove(controller, plugin: self)
        }
        context = nil
        controller = nil
    }

    func receiveMessage(_ data: Data) {
        let message : AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
        if let m = message as? DLSNetworkConnectionBeganMessage {
            
            if controller == nil && context != nil {
                let viewController = NetworkRequestsViewController(nibName: "NetworkRequestsViewController", bundle: nil)!
                context?.add(viewController, plugin: self)
                controller = viewController
            }
            
            controller?.handleBeganMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionCompletedMessage {
            controller?.handleCompletedMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionFailedMessage {
            controller?.handleFailedMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionReceivedDataMessage {
            controller?.handleReceivedDataMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionCancelledMessage {
            controller?.handleCancelMessage(m)
        }
    }
}
