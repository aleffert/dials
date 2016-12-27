//
//  AppDelegate.swift
//  Dials
//
//  Created by Akiva Leffert on 12/5/14.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var consoleWindowController : ConsoleWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        consoleWindowController = ConsoleWindowController(windowNibName: "ConsoleWindow")
        consoleWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        consoleWindowController?.window?.makeKeyAndOrderFront(nil)
    }

}

