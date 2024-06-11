import SwiftUI
import SwiftData
import GPTSpot_Common

@main
struct GPTSpotmacOSApp: App {

    @NSApplicationDelegateAdaptor(GPTAppDelegate.self) var appDelegate
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    private let windowed: Bool = UserDefaults.standard.bool(forKey: UserDefaults.GeneralSettingsKeys.windowed)
    private let windowId = UUID().uuidString

    var body: some Scene {
        Window("", id: windowId) {
            if windowed {
                ContentView()
                    .modelContainer(for: [ChatMessage.self, Template.self])
                    .environment(\.openAIService, OpenAIServiceKey.defaultValue)
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
