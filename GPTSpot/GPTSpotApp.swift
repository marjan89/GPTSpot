import SwiftUI
import Cocoa
import Carbon
import SwiftData

@main
struct GPTSpotApp: App {
    @NSApplicationDelegateAdaptor(GPTAppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
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
