//
//  OptionEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/26/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

extension DLSPopupEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("PopupEditorView") as! PopupEditorView
        view.editor = self
        return view
    }
}


class PopupEditorView: EditorView {
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var popup : NSPopUpButton?
    
    var editor : DLSPopupEditor? {
        didSet {
            let menu = NSMenu()
            for option in editor?.options ?? [] {
                let item = menu.addItemWithTitle(option.label, action: nil, keyEquivalent: "")!
                item.target = self
                item.action = Selector("itemChosen:")
                item.representedObject = option.value
            }
            popup?.menu = menu
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            for item in popup?.menu?.itemArray ?? [] {
                if let object = item.representedObject as? NSObject, value = info?.value where object == value as? NSObject {
                    popup?.selectItem(item)
                }
            }
            name?.stringValue = info?.label ?? ""
        }
    }
    
    func itemChosen(sender : NSMenuItem) {
        if let info = info {
            self.delegate?.editorView(self, changedInfo: info, toValue: sender.representedObject as! NSCoding?)
        }
    }

}
