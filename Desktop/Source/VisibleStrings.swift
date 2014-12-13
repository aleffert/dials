//
//  VisibleStrings.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

enum VisibleStrings : String {
    case NoDeviceSelected = "No Device Selected"
    case Disconnect = "Disconnect"
    case UnknownHost = "Unknown"
    case NoDevicesFound = "Start Your iOS App to Continue"
    
    var rv : String {
        return self.rawValue
    }
}