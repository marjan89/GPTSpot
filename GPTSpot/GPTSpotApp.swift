import SwiftUI
import Cocoa
import Carbon
import SwiftData

@main
struct GPTSpotApp: App {
    
    @NSApplicationDelegateAdaptor(GPTAppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("GPTSpot", image: .menuBar) {
            SettingsLink {
                Text("Settings")
            }
            .keyboardShortcut("S")
            Divider()
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
    var window: NSWindow!
    var hotKeyRef: EventHotKeyRef?
    var globalHotkeyManager: GlobalHotKeyManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow()
        NSApp.setActivationPolicy(
            UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.hideFromDock) ? .accessory : .regular
        )
        globalHotkeyManager = GlobalHotKeyManager(appDelegate: self)
    }
    func setupWindow() {
        window = BorderlessWindow(
            for: NSHostingView(
                rootView: ContentView()
                    .modelContainer(for: [ChatMessage.self, Template.self])
                    .environment(\.openAIService, OpenAIServiceKey.defaultValue)
            )
        )
    }
    
    func toggleWindowVisibility() {
        if window.isVisible {
            window.orderOut(nil)
            NSApp.hide(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
