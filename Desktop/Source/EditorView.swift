//
//  EditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

class EditorInfo : NSObject, EditorConfiguration {
    let editor : DLSEditor
    let name : String
    let label : String
    let value : NSCoding?
    
    init(editor : DLSEditor, name : String, label : String, value : NSCoding?) {
        self.editor = editor
        self.name = name
        self.label = label
        self.value = value
    }
}

private class EditorViewNibOwner {
    @IBOutlet var view : EditorView?
}

/// Subclass this to add a new editor
class EditorView : NSView, EditorController {
    final weak var delegate : EditorControllerDelegate?
    var configuration : EditorConfiguration?
    
    var readOnly : Bool {
        return false
    }
    
    var view : NSView {
        return self
    }
    
    final class func freshViewFromNib(name : String) -> EditorView {
        let owner = EditorViewNibOwner()
        NSBundle.mainBundle().loadNibNamed(name, owner: owner, topLevelObjects: nil)
        return owner.view!
    }
}