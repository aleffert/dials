//
//  SidebarSplitViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/12/14.
//
//

import AppKit

private let SidebarMinWidth : CGFloat = 200.0
private let SidebarSplitViewName = "SidebarSplitViewName"

class EmptyViewController : NSViewController {
    override func loadView() {
        self.view = NSView(frame: CGRectMake(0, 0, 100, 100))
    }
}

class SidebarSplitViewController: NSSplitViewController {
    
//    var resizing = false
//    var sidebarVisible = false
//    var lastSize : CGFloat = SidebarMinWidth
    
    let sidebarItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    let contentItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupItems()
    }
    
    private func setupItems() {
        sidebarItem.collapsed = true
    }
    
    override func viewDidLoad() {
        sidebarItem.holdingPriority = 400
        addSplitViewItem(sidebarItem)
        addSplitViewItem(contentItem)
        hideSidebar()
    }
    
    override func loadView() {
        self.splitView = NSSplitView(frame: CGRectZero)
        self.splitView.vertical = true
        self.splitView.dividerStyle = .Thin
        self.splitView.autosaveName = SidebarSplitViewName
        self.view = self.splitView
    }
    
    func useSidebarContent(view : NSView) {
        for child in sidebarItem.viewController.view.subviews as Array<NSView> {
            if child != view {
                view.removeFromSuperview()
            }
        }
        sidebarItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func useBodyContent(view : NSView) {
        for child in contentItem.viewController.view.subviews as Array<NSView> {
            if child != view {
                view.removeFromSuperview()
            }
        }
        contentItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func showSidebar() {
        sidebarItem.animator().collapsed = false
    }
    
    func hideSidebar() {
        sidebarItem.animator().collapsed = true
    }
//    
//    func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
//        return !sidebarVisible && subview == sidebarView
//    }
//    
//    func splitView(splitView: NSSplitView, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
//        return !sidebarVisible
//    }
//    
//    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//        if resizing && dividerIndex == 0 && !sidebarVisible {
//            return 0
//        }
//        else if resizing && dividerIndex == 0 {
//            return SidebarMinWidth
//        }
//        else {
//            return proposedMinimumPosition
//        }
//    }
//    
//    func splitView(splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
//        return resizing || view == self.contentView
//    }
//    
//    func splitViewWillResizeSubviews(notification: NSNotification) {
//        resizing = notification.userInfo?["NSSplitViewDividerIndex"] != nil
//    }
//    
//    func splitViewDidResizeSubviews(notification: NSNotification) {
//        resizing = false
//        let width = self.sidebarView!.bounds.size.width
//        if width > 0 && sidebarVisible {
//            lastSize = width
//        }
//    }
}
