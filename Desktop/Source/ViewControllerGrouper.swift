//
//  ViewControllerGrouper.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

class NamedGroup<A> {
    var items : [A] = []
    var name : String
    
    init(name : String) {
        self.name = name
    }
}


class ViewControllerGrouper: NSObject {
    
    private var controllers : [NamedGroup<NSViewController>] = []

    func addViewController(controller: NSViewController, groupName: String) {
        for group in controllers {
            if group.name == groupName {
                group.items.append(controller)
                return
            }
        }
    }
    
    func removeViewController(controller: NSViewController, groupName: String) {
        for group in controllers {
            if group.name == groupName {
                group.items.filter { return $0 != controller }
            }
        }
    }
    
    var hasMultipleItems : Bool {
        if controllers.count > 0 {
            return true
        }
        else if controllers.count == 1 && controllers[0].items.count > 1 {
            return true
        }
        return false
    }
    
}
