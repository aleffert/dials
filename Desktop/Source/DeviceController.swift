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
    func deviceControllerUpdatedDevices(controller : DeviceController)
}

class DeviceController : NSObject, NSNetServiceBrowserDelegate, DeviceDelegate {
    private let browser : NSNetServiceBrowser = NSNetServiceBrowser()
    private var devices : [Device] = []
    private var running : Bool = false
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
        let found = countElements(devices.filter { $0.isBackedByNetService(service) }) > 0
        if !found {
            devices.append(Device(service: service, delegate : self))
        }
        if !moreComing {
            delegate?.deviceControllerUpdatedDevices(self)
        }
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        devices = devices.filter{ !$0.isBackedByNetService(service) }
        if !moreComing {
            delegate?.deviceControllerUpdatedDevices(self)
        }
    }
    
    func deviceDidResolveAddress(device: Device) {
        delegate?.deviceControllerUpdatedDevices(self)
    }
    
    
    func saveLastDevice(device : Device?) {
        NSUserDefaults.standardUserDefaults().setObject(device?.serviceName, forKey: LastDeviceServiceKey)
        NSUserDefaults.standardUserDefaults().setObject(device?.hostName, forKey: LastDeviceHostNameKey)
    }
    
}
