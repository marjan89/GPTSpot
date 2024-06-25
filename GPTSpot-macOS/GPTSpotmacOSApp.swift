import SwiftUI
import SwiftData
import GPTSpot_Common

@main
struct GPTSpotmacOSApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    private let windowed: Bool = UserDefaults.standard.bool(forKey: UserDefaults.GeneralSettingsKeys.windowed)
    private let windowId = UUID().uuidString
    @Environment(\.container) var container

    var body: some Scene {
        Window("", id: windowId) {
            if windowed {
                ContentView()
                    .modelContainer(container.resolve(ModelContainer.self))
            } else {
                Image(nsImage: NSImage(imageLiteralResourceName: "AppIcon"))
                    .onAppear {
                        NSApplication.shared.windows.first { window in
                            window.identifier?.rawValue == windowId
                        }?.close()
                    }
            }
        }
        MenuBarExtra("GPTSpot", image: .menuBar) {
            SettingsLink {
                Text("Settings")
            }
            .keyboardShortcut("S")
            Divider()
            Button("Show window") {
                if windowed {
                    openWindow(id: windowId)
                } else {
                    appDelegate.showWindow()
                }
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
