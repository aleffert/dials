//
//  OptionEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/26/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

extension DLSOptionEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("OptionEditorView") as! OptionEditorView
        view.editor = self
        return view
    }
}


class OptionEditorView: EditorView {
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var popup : NSPopUpButton?
    
    var editor : DLSOptionEditor? {
        didSet {
            let menu = NSMenu()
            for option in editor?.options as? [DLSOptionItem] ?? [] {
                let item = menu.addItemWithTitle(option.label, action: nil, keyEquivalent: "")!
                item.target = self
                item.action = Selector("itemChosen:")
                item.representedObject = option.value()
            }
            popup?.menu = menu
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            for item in popup?.menu?.itemArray as? [NSMenuItem] ?? [] {
                if let object = item.representedObject as? NSObject, value = info?.value where object == value as? NSObject {
                    popup?.selectItem(item)
                }
            }
            name?.stringValue = info?.label ?? ""
        }
    }
    
    func itemChosen(sender : NSMenuItem) {
        info.map {
            self.delegate?.editorView(self, changedInfo: $0, toValue: sender.representedObject as! NSCoding?)
        }
    }

}
