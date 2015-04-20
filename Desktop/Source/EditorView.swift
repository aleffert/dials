//
//  LiveDialView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

protocol EditorViewDelegate : class {
    func editorView(view : EditorView, changedInfo info : EditorInfo, toValue value: NSCoding?)
}

private class EditorViewNibOwner {
    @IBOutlet var view : EditorView?
}

struct EditorInfo {
    let editor : DLSEditorDescription
    let name : String
    let value : NSCoding?
}

class EditorView : NSView {
    weak var delegate : EditorViewDelegate?
    var info : EditorInfo?
    
    class func freshViewFromNib(name : String) -> EditorView {
        let owner = EditorViewNibOwner()
        NSBundle.mainBundle().loadNibNamed(name, owner: owner, topLevelObjects: nil)
        return owner.view!
    }
}

@objc protocol EditorViewGenerating : class {
    func generate() -> EditorView
}