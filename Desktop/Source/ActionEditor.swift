//
//  ActionEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

extension DLSActionEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return EditorView.freshViewFromNib("ActionEditorView")
    }
}

class ActionEditorView : EditorView {
    
    @IBOutlet var button : NSButton?
    
    @IBAction func buttonPressed(_ sender : NSButton) {
        self.delegate?.editorController(self, changedToValue: nil)
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            button?.title = configuration!.label
        }
    }
    
    override var readOnly : Bool {
        return true
    }
}
