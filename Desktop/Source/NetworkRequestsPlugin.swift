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
    
    var name : String {
        return DLSNetworkRequestsPluginName
    }
    
    var displayName : String {
        return "Network"
    }
    
    var shouldSortChildren : Bool {
        return true
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        context = nil
        controller = nil
    }

    func receiveMessage(data: NSData) {
        let message : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let m = message as? DLSNetworkConnectionBeganMessage {
            handleBeganMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionCompletedMessage {
            handleCompletedMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionFailedMessage {
            handleFailedMessage(m)
        }
        else if let m = message as? DLSNetworkConnectionReceivedDataMessage {
            handleReceivedDataMessage(m)
        }
    }
    
    func handleBeganMessage(message : DLSNetworkConnectionBeganMessage) {
        if self.controller == nil && self.context != nil {
            let viewController = NetworkRequestsViewController(nibName: nil, bundle: nil)!
            self.context?.addViewController(viewController, plugin: self)
            controller = viewController
        }
    }
    
    func handleCompletedMessage(message : DLSNetworkConnectionCompletedMessage) {
        
    }
    
    func handleFailedMessage(message : DLSNetworkConnectionFailedMessage) {
        
    }
    
    func handleReceivedDataMessage(message : DLSNetworkConnectionReceivedDataMessage) {
        
    }
}
