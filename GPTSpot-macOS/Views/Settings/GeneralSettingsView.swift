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
    @AppStorage(GeneralSettingsDefaultsKeys.startHidden) private var startHidden = false
    @AppStorage(GeneralSettingsDefaultsKeys.hideFromDock) private var hideFromDock = false
    @State private var alertVisible = false

    var body: some View {
        Form {
            LaunchAtLogin.Toggle("Login item")
            Toggle(isOn: $startHidden) {
                Text("Start hidden")
            }
            Toggle(isOn: $hideFromDock) {
                Text("Hide from dock")
                Text("You need to restart the app for this change to take effect")
            }
        }
        .frame(width: 300, height: 150)
    }
}

#Preview {
    GeneralSettingsView()
}
