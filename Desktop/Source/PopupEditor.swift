//
//  OptionEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/26/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

extension DLSPopupEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("PopupEditorView") as! PopupEditorView
        view.editor = self
        return view
    }
}


class PopupEditorView: EditorView {
    @IBOutlet fileprivate var name : NSTextField?
    @IBOutlet fileprivate var popup : NSPopUpButton?
    
    var editor : DLSPopupEditor? {
        didSet {
            let menu = NSMenu()
            for option in editor?.options ?? [] {
                let item = menu.addItem(withTitle: option.label, action: nil, keyEquivalent: "")
                item.target = self
                item.action = #selector(PopupEditorView.itemChosen(_:))
                item.representedObject = option.value
            }
            popup?.menu = menu
        }
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            for item in popup?.menu?.items ?? [] {
                if let object = item.representedObject as? NSObject, let value = configuration?.value, object == value as? NSObject {
                    popup?.select(item)
                }
            }
            name?.stringValue = configuration?.label ?? ""
        }
    }
    
    func itemChosen(_ sender : NSMenuItem) {
        self.delegate?.editorController(self, changedToValue: sender.representedObject as! NSCoding?)
    }

}
