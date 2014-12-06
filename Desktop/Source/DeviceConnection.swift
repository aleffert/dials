//
//  DeviceConnection.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

protocol DeviceConnectionDelegate {
    func connectionClosed(connection : DeviceConnection)
    func connection(connection : DeviceConnection, receivedData : NSData, header : [String:String])
}

class DeviceConnection {
    
    let device : Device
    
    init(device : Device, service : NSNetService) {
        self.device = device
    }
    
    func isConnectedToDevice(device : Device?) -> Bool {
        return self.device.isEqual(device)
    }
    
    func close() {
    }
}
