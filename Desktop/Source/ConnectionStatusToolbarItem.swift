//
//  ConnectionStatusToolbarItem.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

let ConnectionStatusToolbarItemIdentifier = "ConnectionStatusToolbarItemIdentifier"

class ConnectionStatusToolbarItem: NSToolbarItem {
    
    let statusView : ConnectionStatusView
    
    init(itemIdentifier: String, changeBroadcaster : Broadcaster<ConnectionStatus>) {
        self.statusView = ConnectionStatusView(frame : CGRectMake(0, 0, 250, 30))
        super.init(itemIdentifier: itemIdentifier)
        self.view = statusView
        changeBroadcaster.addListener(owner : self) {[weak self] status in
            self?.statusView.useStatus(status)
            return
        }
    }
    
    convenience init(changeBroadcaster : Broadcaster<ConnectionStatus>) {
        self.init(itemIdentifier : ConnectionStatusToolbarItemIdentifier, changeBroadcaster : changeBroadcaster)
    }
}
