//
//  HotkeyManager.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import Cocoa
import SwiftUI

class HotkeyManager: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let eventMask: NSEvent.EventTypeMask = [.keyDown, .keyUp]
        NSEvent.addLocalMonitorForEvents(matching: eventMask) { event in
            print("\(event)")
            if event.modifierFlags.contains(.control) && event.modifierFlags.contains(.shift) && event.keyCode == 49 {
                self.showAppOnDesktop()
            }
            return event
        }

        // Create a popover to display the app content
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: ContentView())
    }

    func showAppOnDesktop() {
        print("show")
    }
}
