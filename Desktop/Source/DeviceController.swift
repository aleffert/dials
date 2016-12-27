//
//  DeviceController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

private let LastDeviceServiceKey = "com.akivaleffert.Dials.LastDeviceServiceKey";
private let LastDeviceHostNameKey = "com.akivaleffert.Dials.LastDeviceHostNameKey";

protocol DeviceControllerDelegate : class {
    func deviceControllerUpdatedDevices(_ controller : DeviceController)
}

class DeviceController : NSObject, NetServiceBrowserDelegate, DeviceDelegate {
    fileprivate let browser : NetServiceBrowser = NetServiceBrowser()
    fileprivate var devices : [Device] = []
    fileprivate var running : Bool = false
    weak var delegate : DeviceControllerDelegate?
    
    func start() {
        if !running {
            browser.includesPeerToPeer = true
            browser.delegate = self
            browser.searchForServices(ofType: DLSNetServiceName, inDomain: "")
        }
        running = true
    }
    
    func stop() {
        if running {
            browser.stop()
        }
        running = false
    }
    
    var knownDevices : [Device] {
        return devices.filter { $0.hasAddress }
    }
    
    var hasDevices : Bool {
        return self.knownDevices.count > 0
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        NSLog("Error starting bonjour browser: \(errorDict)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        let found = (devices.filter { $0.isBackedByNetService(service) }).count > 0
        if !found {
            devices.append(Device(service: service, delegate : self))
        }
        if !moreComing {
            delegate?.deviceControllerUpdatedDevices(self)
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        devices = devices.filter{ !$0.isBackedByNetService(service) }
        if !moreComing {
            delegate?.deviceControllerUpdatedDevices(self)
        }
    }
    
    func deviceDidResolveAddress(_ device: Device) {
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
    
    func saveLastDevice(_ device : Device?) {
        UserDefaults.standard.set(device?.serviceName, forKey: LastDeviceServiceKey)
        UserDefaults.standard.set(device?.hostName, forKey: LastDeviceHostNameKey)
    }
    
}
