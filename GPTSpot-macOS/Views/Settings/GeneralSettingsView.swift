//
//  GeneralSettingsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation
import SwiftUI
import GPTSpot_Common

struct GeneralSettingsView: View {
    @AppStorage(UserDefaults.GeneralSettingsKeys.startHidden) private var startHidden = false
    @AppStorage(UserDefaults.GeneralSettingsKeys.hideFromDock) private var hideFromDock = false
    @AppStorage(UserDefaults.GeneralSettingsKeys.windowed) private var windowed = false
    @AppStorage(UserDefaults.GeneralSettingsKeys.keepOnTop) private var keepOnTop = false
    @AppStorage(UserDefaults.GeneralSettingsKeys.panelTransparency) private var panelTransparency = 1.0
    @AppStorage(UserDefaults.GeneralSettingsKeys.usePanelTransparency) private var usePanelTransparency = false

    var body: some View {
        Form {
            Section("App settings") {
                LaunchAtLogin.Toggle("Login item")
                Toggle(isOn: $startHidden) {
                    Text("Start hidden")
                }
            }
            Section("Window settings") {
                Text("You need to restart the app for this change to take effect")
                    .font(.footnote)
                Toggle(isOn: $windowed) {
                    Text("Windowed mode")
                }
                Toggle(isOn: $keepOnTop) {
                    Text("Keep on top")
                }
                .disabled(!windowed)
                Toggle(isOn: $hideFromDock) {
                    Text("Hide from dock")
                }
                .disabled(!windowed)
            }
            Section("Panel settings") {
                Slider(
                    value: $panelTransparency,
                    in: 0...1,
                    step: 0.1
                ) {
                    Text(String(format: "Panel transparency %.1f", panelTransparency))
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
                .disabled(windowed)
                Toggle(isOn: $usePanelTransparency) {
                    Text("Use panel transparency")
                }
                .disabled(windowed)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    GeneralSettingsView()
}
