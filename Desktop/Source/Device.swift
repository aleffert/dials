//
//  Device.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let DeviceDidResolveAddressNotification : String = "DeviceDidResolveAddressNotification";

protocol DeviceDelegate : class {
    func deviceDidResolveAddress(_ device : Device)
}

class Device: NSObject {
    fileprivate let service : NetService
    fileprivate weak var delegate : DeviceDelegate?
    
    init(service : NetService, delegate : DeviceDelegate) {
        self.service = service
        self.delegate = delegate
        super.init()
        service.delegate = self
        
        if service.hostName == nil {
            service.resolve(withTimeout: 60);
        }
    }
    
    var hasAddress : Bool {
        return service.addresses?.count > 0
    }
    
    var label : String {
        return "\(service.name)@\(service.hostName ?? VisibleStrings.UnknownHost.rv)"
    }
    
    var serviceName : String {
        return service.name
    }
    
    var hostName : String! {
        return service.hostName
    }
    
    func isBackedByNetService(_ service : NetService) -> Bool {
        return self.service.isEqual(service)
    }
    
    func openConnection(delegate : DeviceConnectionDelegate) -> DeviceConnection {
        return DeviceConnection(device : self, service: service, delegate : delegate)
    }
    
    override var hash : Int {
        get {
            return self.service.hash
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let device = object as? Device {
            return device.service .isEqual(self.service)
        }
        return false;
    }
}

extension Device : NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        delegate?.deviceDidResolveAddress(self)
    }
}
