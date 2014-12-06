//
//  DeviceController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

protocol DeviceControllerDelegate : class {
    func deviceControllerUpdatedDevices(controller : DeviceController)
}

class DeviceController : NSObject, NSNetServiceBrowserDelegate, DeviceDelegate {
    let browser : NSNetServiceBrowser = NSNetServiceBrowser()
    var devices : [Device] = []
    var running : Bool = false
    weak var delegate : DeviceControllerDelegate?
    
    func start() {
        if !running {
            browser.delegate = self
            browser.searchForServicesOfType(DLSNetServiceName, inDomain: "")
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
        return countElements(self.knownDevices) > 0
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        let found = countElements(devices.filter { $0.backedByNetService(service) }) > 0
        if !found {
            devices.append(Device(service: service, delegate : self))
        }
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        devices = devices.filter{ !$0.backedByNetService(service) }
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
    func deviceDidResolveAddress(device: Device) {
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
}
