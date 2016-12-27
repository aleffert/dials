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
    
    let block : (A) -> Void
    
    init(_ block : @escaping (A) -> Void) {
        self.block = block
    }
    
    fileprivate func call(_ o : A) {
        block(o)
    }
}

class Broadcaster<A> {
    
    private var listeners : [Listener<A>] = []
    
    @discardableResult func addListener(_ owner : AnyObject? = nil, f : @escaping (A) -> Void) -> Listener<A> {
        let l = Listener(f)
        listeners.append(l)
        
        let _ = owner?.dls_performAction(onDealloc: {[weak self] in
            self?.removeListener(l)
            return
        })
        return l
    }
    
    func removeListener(_ l : Listener<A>) {
        listeners = listeners.filter { g in
            return l === g
        }
    }
    
    func notifyListeners(_ object : A) {
        for listener in listeners {
            listener.call(object)
        }
    }
}
