//
//  ControlListPaneViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/15/15.
//
//

import Cocoa

protocol ControlListPaneViewControllerDelegate : class {
    func paneController(_ controller : ControlListPaneViewController, changedControlInfo info: DLSControlInfo, toValue value : NSCoding?)
    func paneController(_ controller : ControlListPaneViewController, shouldSaveControlInfo info: DLSControlInfo, withValue value : NSCoding?)
}

class ControlListPaneViewController: NSViewController, ControlControllerDelegate {
    
    @IBOutlet fileprivate var stackView : NSStackView?
    fileprivate var controlControllers : [ControlController] = []
    weak var delegate : ControlListPaneViewControllerDelegate?
    let group : String
    
    init?(group : String, delegate : ControlListPaneViewControllerDelegate) {
        self.group = group
        self.delegate = delegate
        super.init(nibName: "ControlListPaneViewController", bundle: nil)
        self.title = group
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for controller in controlControllers {
            self.stackView?.addView(controller.view, in: .top)
        }
    }
    
    var isEmpty : Bool {
        return controlControllers.count == 0
    }
    
    func addControlWithInfo(_ controlInfo : DLSControlInfo) {
        let editorController = (controlInfo.editor as! EditorControllerGenerating).generateController()
        editorController.view.translatesAutoresizingMaskIntoConstraints = false
        let controller = ControlController(controlInfo : controlInfo, contentController : editorController, delegate : self)
        controlControllers.append(controller)
        controlControllers.sort { (left, right) -> Bool in
            left < right
        }
        let i = controlControllers.index(of: controller)!
        if(self.isViewLoaded) {
            NSAnimationContext.runAnimationGroup({ctx in
                ctx.allowsImplicitAnimation = true
                self.stackView?.insertView(controller.view, at: i, in: .top)
            }, completionHandler: nil)
        }
    }
    
    func removeControlWithID(_ controlID : String) {
        let index = controlControllers.indexOf {
            $0.controlInfo.uuid == controlID
        }
        guard let i = index else {
            return
        }
        
        guard let view = self.stackView?.views[i] else {
            return
        }
        
        self.controlControllers.remove(at: i)
        
        NSAnimationContext.runAnimationGroup({ctx in
            ctx.allowsImplicitAnimation = true
            self.stackView?.removeView(view)
            }, completionHandler: nil)
    }

    func controlController(_ controller: ControlController, changedControlInfo info: DLSControlInfo, toValue value: NSCoding?) {
        delegate?.paneController(self, changedControlInfo: info, toValue: value)
    }
    
    func controlController(_ controller: ControlController, shouldSaveControlInfo info: DLSControlInfo, withValue value: NSCoding?) {
        delegate?.paneController(self, shouldSaveControlInfo: info, withValue: value)
    }
    

}
