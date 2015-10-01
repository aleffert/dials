//
//  ConstraintsEditorController.swift
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation
import Cocoa

class ConstraintsEditorController : NSObject, EditorController, ViewQuerierOwner, ConstraintViewDelegate {
    weak var delegate : EditorControllerDelegate?
    var viewQuerier : ViewQuerier?
    var lastConstraints : [DLSConstraintDescription] = []
    
    @IBOutlet private var editorView : NSView!
    @IBOutlet private var nothingLabel : NSView!
    @IBOutlet private var constraintStack : NSStackView!
    
    override init() {
        super.init()
        NSBundle.mainBundle().loadNibNamed("ConstraintsEditorView", owner: self, topLevelObjects: nil)
    }
    
    var readOnly : Bool {
        return true
    }
    
    var view : NSView {
        return editorView!
    }
    
    private func firstPartOfConstraintDescription(description : DLSConstraintDescription) -> String {
        guard let source = viewQuerier?.nameForViewWithID(
            description.sourceViewID,
            relativeToView: description.affectedViewID,
            withClass: description.sourceClass) else {
                return "Internal Error"
        }
        return "\(source).\(description.sourceAttribute)"
    }
    
    private func secondPartOfConstraintDescription(description : DLSConstraintDescription) -> String {
        let dest = viewQuerier?.nameForViewWithID(
            description.destinationViewID,
            relativeToView: description.affectedViewID,
            withClass: description.destinationClass)
        if let destName = dest, destAttribute = description.destinationAttribute {
            var result = "\(destName).\(destAttribute)"
            if description.multiplier != 1 {
                result = result + " * \(stringFromNumber(description.multiplier))"
            }
            if description.constant != 0 {
                result = result + " + \(stringFromNumber(description.constant))"
            }
            return result
        }
        else {
            return "\(description.constant)"
        }
    }
    
    var configuration : EditorConfiguration? {
        didSet {
            if let constraints = configuration?.value as? [DLSConstraintDescription] where constraints.count > 0 {
                
                constraintStack.hidden = false
                nothingLabel.hidden = true
                
                guard constraints != lastConstraints else {
                    return
                }
                
                lastConstraints = constraints
                constraintStack.setViews([], inGravity: .Top)
                
                for constraint in constraints {
                    let owner = ConstraintViewOwner()
                    NSBundle.mainBundle().loadNibNamed("ConstraintView", owner: owner, topLevelObjects: nil)
                    if let view = owner.constraintView {
                        view.delegate = self
                        constraintStack.addView(view, inGravity: .Top)
                        view.constraint = constraint
                        view.fields = (
                            first: firstPartOfConstraintDescription(constraint),
                            relation: constraint.relation,
                            second: secondPartOfConstraintDescription(constraint)
                        )
                    }
                }
            }
            else {
                constraintStack.hidden = true
                nothingLabel.hidden = false
            }
        }
    }
    
    func constraintView(constraintView: ConstraintView, clearedHighlightViewWithID viewID: String) {
        self.viewQuerier?.clearHighlightForViewWithID(viewID)
    }
    
    func constraintView(constraintView: ConstraintView, choseHighlightViewWithID viewID: String) {
        self.viewQuerier?.highlightViewWithID(viewID)
    }
    
    func constraintView(constraintView: ConstraintView, selectedViewWithID viewID: String) {
        self.viewQuerier?.selectViewWithID(viewID)
    }
    
    func constraintView(constraintView: ConstraintView, updatedConstant constant: CGFloat, constraintID: String) {
        self.delegate?.editorController(self, changedConfiguration: self.configuration!, toValue: DLSUpdateConstraintConstantMessage(constraintID: constraintID, constant: constant))
        if let constraint = constraintView.constraint {
            constraintView.fields = (
                first: firstPartOfConstraintDescription(constraint),
                relation: constraint.relation,
                second: secondPartOfConstraintDescription(constraint)
            )
        }
    }

}

extension DLSConstraintsEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return ConstraintsEditorController()
    }
}
