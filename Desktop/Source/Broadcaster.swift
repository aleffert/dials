//
//  Broadcaster.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

class Listener<A> {
    
    let block : A -> Void
    
    init(block : A -> Void) {
        self.block = block
    }
    
    func call(o : A) {
        block(o)
    }
}

class Broadcaster<A>: NSObject {
    
    private var listeners : [Listener<A>] = []
    
    func addListener(f : A -> Void, owner : AnyObject? = nil) -> Listener<A> {
        let l = Listener(f)
        listeners.append(l)
        
        owner?.performActionOnDealloc{[weak self] in
            self?.removeListener(l)
            return
        }
        return l
    }
    
    func removeListener(l : Listener<A>) {
        listeners = listeners.filter { g in
            return l === g
        }
    }
    
    func notifyListeners(object : A) {
        for listener in listeners {
            listener.call(object)
        }
    }
}
