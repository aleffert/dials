//
//  DeviceConnection.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

protocol DeviceConnectionDelegate : class {
    func connectionClosed(_ connection : DeviceConnection)
    func connection(_ connection : DeviceConnection, receivedData : Data, channel : DLSChannel)
}

class DeviceConnection : NSObject, DLSChannelStreamDelegate  {
    
    let device : Device
    fileprivate let stream : DLSChannelStream
    
    fileprivate weak var delegate : DeviceConnectionDelegate?
    
    init(device : Device, service : NetService, delegate : DeviceConnectionDelegate) {
        self.device = device
        self.delegate = delegate
        self.stream = DLSChannelStream(netService: service)
        super.init()
        self.stream.delegate = self
    }
    
    func isConnectedToDevice(_ device : Device?) -> Bool {
        return self.device.isEqual(device)
    }
    
    func close() {
        self.stream.close()
    }
    
    func sendMessage(_ message : Data, channel : DLSChannel) {
        self.stream.sendMessage(message, on: channel)
    }
    
    func stream(_ stream: DLSChannelStream, receivedMessage data: Data, on channel: DLSChannel) {
        delegate?.connection(self, receivedData: data, channel: channel)
    }
    
    func streamClosed(_ stream: DLSChannelStream) {
        delegate?.connectionClosed(self)
    }
}
