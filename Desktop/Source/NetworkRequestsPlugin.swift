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
    
    let identifier = DLSNetworkRequestsPluginName
    
    let label = "Network"
    
    let shouldSortChildren = true
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        controller.map { self.context?.removeViewController($0, plugin: self) }
        context = nil
        controller = nil
    }

    func receiveMessage(data: NSData) {
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
