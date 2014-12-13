//
//  DeviceConnection.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

protocol DeviceConnectionDelegate : class {
    func connectionClosed(connection : DeviceConnection)
    func connection(connection : DeviceConnection, receivedData : NSData, channel : DLSOwnedChannel)
}

class DeviceConnection : DLSChannelStreamDelegate {
    
    let device : Device
    private let stream : DLSChannelStream
    
    private weak var delegate : DeviceConnectionDelegate?
    
    init(device : Device, service : NSNetService, delegate : DeviceConnectionDelegate) {
        self.device = device
        self.delegate = delegate
        self.stream = DLSChannelStream(netService: service)
        self.stream.delegate = self
    }
    
    func isConnectedToDevice(device : Device?) -> Bool {
        return self.device.isEqual(device)
    }
    
    func close() {
        self.stream.close()
    }
    
    func sendMessage(message : NSData, channel : DLSChannel) {
        self.stream.sendMessage(message, onChannel: channel)
    }
    
    func stream(stream: DLSChannelStream!, receivedMessage data: NSData!, onChannel channel: DLSOwnedChannel!) {
        delegate?.connection(self, receivedData: data, channel: channel)
    }
    
    func streamClosed(stream: DLSChannelStream!) {
        delegate?.connectionClosed(self)
    }
}
