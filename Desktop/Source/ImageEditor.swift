//
//  ImageEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

extension DLSImageEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return EditorView.freshViewFromNib("ImageEditorView")
    }
}

class ImageEditorView: EditorView {
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var imageWell : NSImageView?
    
    override var configuration : EditorConfiguration? {
        didSet {
            let image = (configuration?.value as? NSData).flatMap { NSImage(data: $0) }
            imageWell?.image = image
            name?.stringValue = configuration?.label ?? "Image"
        }
    }
    
    @IBAction func imageChanged(sender : NSImageView) {
        // per http://stackoverflow.com/questions/3038820/how-to-save-a-nsimage-as-a-new-file
        if let tiffData = sender.image?.TIFFRepresentation,
            rep = NSBitmapImageRep(data:tiffData)
        {
            let imageData = rep.representationUsingType(.NSPNGFileType, properties:[:])
            delegate?.editorController(self, changedToValue: imageData)
        }
    }
}
