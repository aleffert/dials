//
//  ActionEditorView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/20/15.
//
//

import Foundation
import AppKit

extension DLSActionEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        return EditorView.freshViewFromNib("ActionEditorView")
    }
}

class ActionEditorView : EditorView {
    
    @IBOutlet var button : NSButton?
    
    @IBAction func buttonPressed(sender : NSButton) {
        if let info = info {
            self.delegate?.editorView(self, changedInfo: info, toValue: nil)
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            button?.title = info!.label
        }
    }
    
    override var readOnly : Bool {
        return true
    }
}