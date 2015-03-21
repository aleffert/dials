//
//  LiveDialController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/19/15.
//
//

import Foundation
import AppKit

protocol LiveDialControllerDelegate : class {
    func dialController(controller : LiveDialController, changedDial dial : DLSLiveDial, toValue value : NSCoding?)
}

class LiveDialController : LiveDialViewDelegate, Equatable {
    let contentView : LiveDialView
    weak var delegate : LiveDialControllerDelegate?
    
    init(dial : DLSLiveDial, contentView : LiveDialView, delegate : LiveDialControllerDelegate) {
        contentView.dial = dial
        self.delegate = delegate
        self.contentView = contentView
        contentView.delegate = self
    }
    
    func dialView(view: LiveDialView, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        delegate?.dialController(self, changedDial:dial, toValue: value)
    }
    
    var dial : DLSLiveDial? {
        return contentView.dial
    }
    
    var view : NSView {
        return self.contentView
    }
    
}

func < (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.displayName < right.contentView.dial?.displayName
}

func == (left : LiveDialController, right : LiveDialController) -> Bool {
    return left.contentView.dial?.uuid == right.contentView.dial?.uuid
}