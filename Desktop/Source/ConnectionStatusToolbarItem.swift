//
//  ConnectionStatusToolbarItem.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

let ConnectionStatusToolbarItemIdentifier = "ConnectionStatusToolbarItemIdentifier"

enum ConnectionStatus {
    case None
    case Available([Device])
}

class ConnectionStatusToolbarItem: NSToolbarItem {
    
    let statusView : ConnectionStatusView
    
    init(itemIdentifier: String, changeBroadcaster : Broadcaster<ConnectionStatus>) {
        self.statusView = ConnectionStatusView(frame : CGRectMake(0, 0, 250, 30))
        super.init(itemIdentifier: itemIdentifier)
        self.view = statusView
        changeBroadcaster.addListener({[weak self] r in
            switch r {
            case .None:
                self?.statusView.showNoDevicesLabel()
            case let .Available(devices):
                self?.statusView.showDevices(devices)
            }
            }, owner : self)
    }
    
    convenience init(changeBroadcaster : Broadcaster<ConnectionStatus>) {
        self.init(itemIdentifier : ConnectionStatusToolbarItemIdentifier, changeBroadcaster : changeBroadcaster)
    }
}
