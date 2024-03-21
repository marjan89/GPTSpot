//
//  GeneralSettingsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation
import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(GeneralSettingsDefaultsKeys.loginItem) private var loginItem = false
    @AppStorage(GeneralSettingsDefaultsKeys.startHidden) private var startHidden = false
    @AppStorage(GeneralSettingsDefaultsKeys.showHelpRibbon) private var showHelpRibbon = true
    @AppStorage(GeneralSettingsDefaultsKeys.showStats) private var showStats = true
    
    var body: some View {
        Form {
            Toggle(isOn: $loginItem) {
                Text("Login item")
                    .foregroundColor(.red)
            }
            Toggle(isOn: $startHidden) {
                Text("Start hidden")
            }
            Toggle(isOn: $showHelpRibbon) {
                Text("Show help ribbon")
            }
            Toggle(isOn: $showStats) {
                Text("Show stats")
            }
        }
        .padding(20)
        .frame(width: 300, height: 150)
    }
}
