//
//  DeviceController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa
import DialsShared

protocol DeviceControllerDelegate : class {
    func deviceControllerUpdatedDevices(controller : DeviceController)
}

class DeviceController : NSObject, NSNetServiceBrowserDelegate, DeviceDelegate {
    let browser : NSNetServiceBrowser
    var devices : [Device]
    var running : Bool = false
    weak var delegate : DeviceControllerDelegate?
    
    override init() {
        browser = NSNetServiceBrowser()
        devices = []
        super.init()
    }
    
    func start() {
        if !running {
            browser.searchForServicesOfType(DialsNetServiceName, inDomain: "")
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
        if found {
            devices.append(Device(service: service))
        }
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        self.devices = self.devices.filter{ !$0.backedByNetService(service) }
    }
    
    func deviceDidResolveAddress(device: Device) {
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
}
