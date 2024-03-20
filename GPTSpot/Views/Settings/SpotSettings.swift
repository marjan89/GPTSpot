//
//  SpotSettings.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/18/24.
//

import SwiftUI

enum Tabs {
    case general
    case aiServer
    case keys
}

struct SpotSettings: View {
    @State private var selectedTab = Tabs.general
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            AIServerSettingsView()
                .tabItem {
                    Label("AI Server", systemImage: "server.rack")
                }
                .tag(Tabs.aiServer)
            KeysSettingsView()
                .tabItem {
                    Label("Keys", systemImage: "arrowkeys.left.filled")
                }
                .tag(Tabs.keys)
        }
        .padding(20)
    }
}

#Preview {
    SpotSettings()
}
