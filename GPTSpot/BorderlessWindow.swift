//
//  BorderlessWindow.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/16/24.
//

import Foundation
import Cocoa

class BorderlessWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }

    init(for contentView: NSView) {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 800), styleMask: [.borderless], backing: .buffered, defer: false)
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.contentView?.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.level = .floating
        self.makeKey()
        self.center()
        self.contentView = contentView
        if UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.startHidden) {
            self.orderOut(nil)
        } else {
            self.makeKeyAndOrderFront(nil)
        }
    }
}
