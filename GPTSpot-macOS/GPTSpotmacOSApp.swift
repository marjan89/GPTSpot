import SwiftUI
import Cocoa
import Carbon
import SwiftData
import GPTSpot_Common

@main
struct GPTSpotmacOSApp: App {

    @NSApplicationDelegateAdaptor(GPTAppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("GPTSpot", image: .menuBar) {
            SettingsLink {
                Text("Settings")
            }
            .keyboardShortcut("S")
            Divider()
            Button("Show window") {
                appDelegate.showWindow()
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("Q")
        }
        Settings {
            SpotSettings()
        }
    }
}
class GPTAppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var hotKeyRef: EventHotKeyRef?
    var globalHotkeyManager: GlobalHotKeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        createWindow()
        NSApp.setActivationPolicy(
            UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.hideFromDock) ? .accessory: .regular
        )
        globalHotkeyManager = GlobalHotKeyManager(appDelegate: self)
    }

    func createWindow() {
        if UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.windowed) {
            setupRegularWindow()
        } else {
            setupBorderlessWindow()
        }
    }

    func setupRegularWindow() {
        window = RegularWindow(
            for: NSHostingView(
                rootView: ContentView()
                    .modelContainer(for: [ChatMessage.self, Template.self])
                    .environment(\.openAIService, OpenAIServiceKey.defaultValue)
            )

        )
    }

    func setupBorderlessWindow() {
        window = BorderlessWindow(
            for: NSHostingView(
                rootView: ContentView()
                    .modelContainer(for: [ChatMessage.self, Template.self])
                    .environment(\.openAIService, OpenAIServiceKey.defaultValue)
            )
        )
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
