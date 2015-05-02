//
//  ActionEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

extension DLSActionDescription : EditorViewGenerating {
    func generate() -> EditorView {
        return EditorView.freshViewFromNib("ActionEditorView")
    }
}

class ActionEditorView : EditorView {
    
    @IBOutlet var button : NSButton?
    
    @IBAction func buttonPressed(sender : NSButton) {
        info.map {
            self.delegate?.editorView(self, changedInfo: $0, toValue: nil)
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            button?.title = info!.displayName
        }
    }
}