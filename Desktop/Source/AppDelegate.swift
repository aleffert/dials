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
    
    var consoleWindowController : ConsoleWindowController?


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        consoleWindowController = ConsoleWindowController(windowNibName: "ConsoleWindow")
        consoleWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        consoleWindowController?.window?.makeKeyAndOrderFront(nil)
    }

}

