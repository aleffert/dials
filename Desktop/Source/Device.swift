//
//  Device.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

let DeviceDidResolveAddressNotification : String = "DeviceDidResolveAddressNotification";

protocol DeviceDelegate : class {
    func deviceDidResolveAddress(device : Device)
}

class Device: NSObject, NSNetServiceDelegate {
    
    let service : NSNetService
    weak var delegate : DeviceDelegate?
    
    init(service : NSNetService, delegate : DeviceDelegate) {
        self.service = service
        self.delegate = delegate
        super.init()
        service.delegate = self
        
        if service.hostName == nil {
            service.resolveWithTimeout(60);
        }
    }
    
    var hasAddress : Bool {
        return service.addresses?.count > 0
    }
    
    var displayName : String {
        return "\(service.name)@\(service.hostName ?? VisibleStrings.UnknownHost.rv)"
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        delegate?.deviceDidResolveAddress(self)
    }
    
    func backedByNetService(service : NSNetService) -> Bool {
        return self.service.isEqual(service)
    }
    
    func hash() -> Int {
        return self.service.hash;
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let device = object as? Device {
            return device.service .isEqual(self.service)
        }
        return false;
    }
    
    
}
