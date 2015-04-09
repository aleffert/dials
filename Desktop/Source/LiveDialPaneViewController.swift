//
//  LiveDialPaneViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/15/15.
//
//

import Cocoa
class FlippedClipView : NSClipView {
    override var flipped : Bool {
        return true;
    }
}

protocol LiveDialPaneViewControllerDelegate : class {
    func paneController(controller : LiveDialPaneViewController, changedDial dial: DLSLiveDial, toValue value : NSCoding?)
    func paneController(controller : LiveDialPaneViewController, shouldSaveDial dial: DLSLiveDial, withValue value : NSCoding?)
}

class LiveDialPaneViewController: NSViewController, LiveDialControllerDelegate {
    
    @IBOutlet private var stackView : NSStackView?
    private var dialControllers : [LiveDialController] = []
    weak var delegate : LiveDialPaneViewControllerDelegate?
    let channel : DLSChannel
    
    init?(channel : DLSChannel, delegate : LiveDialPaneViewControllerDelegate) {
        self.channel = channel
        self.delegate = delegate
        super.init(nibName: "LiveDialPaneViewController", bundle: nil)
        self.title = channel.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for controller in dialControllers {
            self.stackView?.addView(controller.view, inGravity: .Top)
        }
    }
    
    var isEmpty : Bool {
        return self.dialControllers.count == 0
    }
    
    func addDial(dial : DLSLiveDial) {
        let contentView = (dial.editor as! LiveDialViewGenerating).generate()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let controller = LiveDialController(dial : dial, contentView : contentView, delegate : self)
        dialControllers.append(controller)
        dialControllers.sort { (left, right) -> Bool in
            left < right
        }
        let i = find(dialControllers, controller)!
        if(self.viewLoaded) {
            NSAnimationContext.runAnimationGroup({ctx in
                ctx.allowsImplicitAnimation = true
                self.stackView?.insertView(controller.view, atIndex: i, inGravity: .Top)
            }, completionHandler: nil)
        }
    }
    
    func removeDialWithID(dialID : String) {
        let index = dialControllers.indexOf {
            $0.dial?.uuid == dialID
        }
        if index != NSNotFound {
            self.dialControllers.removeAtIndex(index)
            let view = self.stackView?.views[index] as! NSView
            
            NSAnimationContext.runAnimationGroup({ctx in
                ctx.allowsImplicitAnimation = true
                self.stackView?.removeView(view)
                }, completionHandler: nil)
        }
    }
    
    func dialController(controller: LiveDialController, changedDial dial: DLSLiveDial, toValue value: NSCoding?) {
        delegate?.paneController(self, changedDial: dial, toValue: value)
    }
    
    func dialController(controller: LiveDialController, shouldSaveDial dial: DLSLiveDial, withValue value: NSCoding?) {
        delegate?.paneController(self, shouldSaveDial: dial, withValue: value)
    }
    

}
