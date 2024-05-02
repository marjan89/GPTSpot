//
//  GeneralSettingsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation
import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(GeneralSettingsDefaultsKeys.startHidden) private var startHidden = false
    
    var body: some View {
        Form {
            LaunchAtLogin.Toggle("Login item")
            Toggle(isOn: $startHidden) {
                Text("Start hidden")
            }
        }
        .frame(width: 300, height: 150)
    }
}

#Preview {
    GeneralSettingsView()
}
