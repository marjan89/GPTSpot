//
//  BorderlessWindow.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/16/24.
//

import Foundation
import Cocoa
import GPTSpot_Common

class RegularWindow: NSWindow {

    private let autoSaveName = "GPTSpotWindow"

    override var canBecomeKey: Bool {
        return true
    }

    init(for contentView: NSView) {
        let screenRect = NSScreen.main?.frame ?? NSRect.zero

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: screenRect.width * 0.6, height: screenRect.height * 0.8),
            styleMask: [.titled, .resizable, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        self.isOpaque = true
        if UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.keepOnTop) {
            self.level = .floating
        }
        self.minSize = NSSize(width: 200, height: 200)
        self.isReleasedWhenClosed = false
        self.makeKey()
        self.setFrameAutosaveName(autoSaveName)
        self.contentView = contentView
        if UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.startHidden) {
            self.orderOut(nil)
        } else {
            self.makeKeyAndOrderFront(nil)
        }
    }
}
