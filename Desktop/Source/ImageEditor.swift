//
//  ImageEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

extension DLSImageEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        return EditorView.freshViewFromNib("ImageEditorView")
    }
}

class ImageEditorView: EditorView {
    @IBOutlet private var name : NSTextField?
    @IBOutlet private var imageWell : NSImageView?
    
    override var info : EditorInfo? {
        didSet {
            let image = (info?.value as? NSData).flatMap { NSImage(data: $0) }
            imageWell?.image = image
            name?.stringValue = info?.label ?? "Image"
        }
    }
    
    @IBAction func imageChanged(sender : NSImageView) {
        // per http://stackoverflow.com/questions/3038820/how-to-save-a-nsimage-as-a-new-file
        if let tiffData = sender.image?.TIFFRepresentation, info = info {
            NSBitmapImageRep(data:tiffData).map {rep -> Void in
                let imageData = rep.representationUsingType(.NSPNGFileType, properties:[:])
                delegate?.editorView(self, changedInfo: info, toValue: imageData)
            }
        }
    }
}
