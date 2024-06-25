//
//  GPTAppDelegate.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 10/6/24.
//

import Foundation
import Cocoa
import Carbon
import GPTSpot_Common
import SwiftUI
import SwiftData

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var hotKeyRef: EventHotKeyRef?
    var globalHotkeyManager: GlobalHotKeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if !UserDefaults.standard.bool(forKey: UserDefaults.GeneralSettingsKeys.windowed) {
            window = BorderlessWindow(
                for: NSHostingView(
                    rootView: ContentView()
                        .modelContainer(Container.shared.resolve(ModelContainer.self))
                )
            )
        }
        let windowed = UserDefaults.standard.bool(forKey: UserDefaults.GeneralSettingsKeys.windowed)
        let hideFromDock = UserDefaults.standard.bool(forKey: UserDefaults.GeneralSettingsKeys.hideFromDock)
        if !windowed {
            NSApp.setActivationPolicy(.accessory)
        } else {
            NSApp.setActivationPolicy(hideFromDock ? .accessory: .regular)
        }
        globalHotkeyManager = GlobalHotKeyManager(appDelegate: self)
    }

    func showWindow() {
        guard let window = window else {
            return
        }
        if !window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func toggleWindowVisibility() {
        guard let window = window else {
            return
        }
        if window.isVisible {
            window.orderOut(nil)
            NSApp.hide(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
