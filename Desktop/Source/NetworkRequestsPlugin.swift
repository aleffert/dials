//
//  NetworkPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/2/15.
//
//

import Cocoa

class NetworkRequestsPlugin: Plugin {
    
    var context : PluginContext?
    var controller : NetworkRequestsViewController?
    
    @objc var name : String {
        return DLSNetworkRequestsPluginName
    }
    
    @objc var displayName : String {
        return "Network"
    }
    
    @objc var shouldSortChildren : Bool {
        return true
    }
    
    @objc func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    @objc func connectionClosed() {
        controller.map { self.context?.removeViewController($0, plugin: self) }
        context = nil
        controller = nil
    }

    @objc func receiveMessage(data: NSData) {
        let message : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let m = message as? DLSNetworkConnectionBeganMessage {
            
            if controller == nil && context != nil {
                let viewController = NetworkRequestsViewController(nibName: "NetworkRequestsViewController", bundle: nil)!
                context?.addViewController(viewController, plugin: self)
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
    }
}
