import SwiftUI
import Cocoa
import Carbon
import SwiftData

@main
struct GPTSpotApp: App {
    
    @NSApplicationDelegateAdaptor(GPTAppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("GPTSpot", systemImage: "gear") {
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
    var eventTapManager: EventTapManager?
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindow()
        eventTapManager = EventTapManager(lightning: self)
    }
    func setupWindow() {
        window = BorderlessWindow(
            for: NSHostingView(
                rootView: ContentView()
                    .modelContainer(for: ChatMessage.self)
            )
        )
    }
    
    func toggleWindowVisibility() {
        if window.isVisible {
            window.orderOut(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
