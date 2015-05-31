//
//  Broadcaster.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/7/14.
//
//

import Cocoa

/// Just a block + equality
class Listener<A> {
    
    let block : A -> Void
    
    init(_ block : A -> Void) {
        self.block = block
    }
    
    private func call(o : A) {
        block(o)
    }
}

class Broadcaster<A> {
    
    private var listeners : [Listener<A>] = []
    
    func addListener(owner : AnyObject? = nil, f : A -> Void) -> Listener<A> {
        let l = Listener(f)
        listeners.append(l)
        
        owner?.dls_performActionOnDealloc{[weak self] in
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
