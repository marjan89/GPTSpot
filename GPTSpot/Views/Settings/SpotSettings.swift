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
    @State private var selectedTab = Tabs.aiServer
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AIServerSettingsView()
                .tabItem {
                    Label("AI Server", systemImage: "brain")
                }
                .tag(Tabs.aiServer)
            KeysSettingsView()
                .tabItem {
                    Label("Keys", systemImage: "keyboard")
                }
                .tag(Tabs.keys)
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .padding(20)
    }
}

#Preview {
    SpotSettings()
}
