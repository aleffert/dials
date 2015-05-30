//
//  FloatArrayEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/22/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

extension DLSFloatArrayEditor : EditorViewGenerating {
    func generateView() -> EditorView {
        let view = EditorView.freshViewFromNib("FloatArrayEditorView") as! FloatArrayEditorView
        view.editor = self
        return view
    }
}


extension DLSFloatArrayEditor : CodeGenerating {
    
    func codeForValue(value: NSCoding?, language: Language) -> String {
        let constructor = self.constructor ?? ""
        
        let values = value as? [String:NSNumber] ?? [:]
        let fields = (labels as? [String]) ?? []
        let params = fields.map {key -> (String, String) in
            let value = stringFromNumber(values[key] ?? (0 as NSNumber))
            return (key, value)
        }
        return constructor.formatWithParameters(Dictionary(elements : params))
    }
    
}

private class FloatArrayItem {
    let label : String
    var value : Float
    
    init(label : String, value : Float) {
        self.label = label
        self.value = value
    }
}

protocol FloatArrayItemViewDelegate : class {
    func view(view : FloatArrayItemView, changedValue: Double)
}

class FloatArrayItemView : NSView {
    
    @IBOutlet var label : NSTextField?
    @IBOutlet var field : NSTextField?
    @IBOutlet var stepper : NSStepper?
    
    weak var delegate : FloatArrayItemViewDelegate?
    
    override func awakeFromNib() {
        stepper?.minValue = -Double(FLT_MAX)
        stepper?.maxValue = Double(FLT_MAX)
        stepper?.increment = 1
    }

    @IBAction func textChanged(sender : NSTextField) {
        stepper?.floatValue = field?.floatValue ?? 0
        delegate?.view(self, changedValue: sender.doubleValue)
    }

    @IBAction func stepperChanged(sender : NSStepper) {
        field?.floatValue = sender.floatValue
        delegate?.view(self, changedValue: sender.doubleValue)
    }

    func useValue(value : String) {
        stepper?.stringValue = value
        field?.stringValue = value
    }

}

class FloatArrayItemViewNibOwner {
    @IBOutlet private var view : FloatArrayItemView?
}

class FloatArrayEditorView : EditorView, FloatArrayItemViewDelegate {
    
    @IBOutlet private var container : NSView!
    @IBOutlet private var name : NSTextField?
    
    private var orderedFields : [FloatArrayItemView] = []
    private var indexedFields : [String:FloatArrayItemView] = [:]
    
    private func columnCountForItemCount(count : Int) -> Int {
        if orderedFields.count < 2 {
            return 1
        }
        else if orderedFields.count < 8 {
            return 2
        }
        else if orderedFields.count < 15 {
            return 3
        }
        else {
            return 4
        }
    }
    
    private func addConstraintsForEditors() {
        let columns = columnCountForItemCount(orderedFields.count)
        
        var first : NSView? = nil
        for ((view, prev), i) in orderedFields.withPrevious().indexed() {
            let column = i % columns
            
            let leadingAnchor : NSView
            let leadingAlignAttribute : NSLayoutAttribute
            let leadingOffset : CGFloat
            let topAnchor : NSView
            let topAlignAttribute : NSLayoutAttribute
            let topOffset : CGFloat
            
            if let prev = prev {
                if column == 0 {
                    leadingAnchor = container
                    leadingAlignAttribute = .Leading
                    leadingOffset = 0
                    topAnchor = prev
                    topAlignAttribute = .Bottom
                    topOffset = 4
                    
                }
                else {
                    leadingAnchor = prev
                    leadingAlignAttribute = .Trailing
                    leadingOffset = 4
                    topAnchor = prev
                    topAlignAttribute = .Top
                    topOffset = 0
                }
                
                let widthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: first!, attribute: .Width, multiplier: 1, constant: 0)
                container.addConstraint(widthConstraint)
            }
            else {
                leadingAnchor = container
                leadingAlignAttribute = .Leading
                leadingOffset = 0
                topAnchor = container
                topAlignAttribute = .Top
                topOffset = 0
            }
            
            let topConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: topAnchor, attribute: topAlignAttribute, multiplier: 1, constant: topOffset)
            container.addConstraint(topConstraint)
            
            let leadingConstraint = NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: leadingAnchor, attribute: leadingAlignAttribute, multiplier: 1, constant: leadingOffset)
            container.addConstraint(leadingConstraint)
            
            if column + 1 == columns {
                let trailingConstraint = NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: container, attribute: .Trailing, multiplier: 1, constant: 0)
                container.addConstraint(trailingConstraint)
            }
            
            if i + 1 == orderedFields.count {
                let bottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0)
                container.addConstraint(bottomConstraint)
            }
            
            if first == nil {
                first = view
            }
            
        }
    }
    
    private var editor : DLSFloatArrayEditor? {
        didSet {
            for label in (editor?.labels ?? []) as! [String] {
                let owner = FloatArrayItemViewNibOwner()
                NSBundle.mainBundle().loadNibNamed("FloatArrayItemView", owner: owner, topLevelObjects: nil)
                owner.view.map { view -> Void in
                    view.label?.stringValue = label
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.delegate = self
                    orderedFields.append(view)
                    indexedFields[label] = view
                    container.addSubview(view)
                }
            }
            
            addConstraintsForEditors()
        }
    }
    
    override var info : EditorInfo? {
        didSet {
            let values = (info?.value as? [String:NSNumber]) ?? [:]
            for (key, value) in values {
                let field = indexedFields[key]
                field?.useValue(stringFromNumber(value, requireIntegerPart: false))
            }
            
            name?.stringValue = info?.label ?? ""
        }
    }
    
    func view(view: FloatArrayItemView, changedValue value: Double) {
        var values = (info?.value as? [String:NSNumber]) ?? [:]
        values[view.label!.stringValue] = value as NSNumber
        info.map {
            delegate?.editorView(self, changedInfo: $0, toValue: values)
        }
    }
}