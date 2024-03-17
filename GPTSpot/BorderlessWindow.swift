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
        super.init(contentRect: NSRect(x: 0, y: 0, width: 800, height: 600), styleMask: [.borderless], backing: .buffered, defer: false)
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.contentView?.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.setFrameAutosaveName("gpt-spot")
        self.level = .floating
        self.makeKey()
        self.center()
        self.contentView = contentView
        //        self.minSize = NSMakeSize(480, 600)
        //        self.maxSize = NSMakeSize(CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude)
//        self.orderOut(nil)
        self.makeKeyAndOrderFront(nil)
    }
}
