//
//  SettingsView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI
import GPTSpot_Common

struct SettingsView: View {
    @AppStorage(AIServerDefaultsKeys.aiModel) private var aiModel = GPTModels.models.first ?? "no models defined"
    @AppStorage(AIServerDefaultsKeys.temperature) private var temperature = 0.5
    @AppStorage(AIServerDefaultsKeys.openAiKey) private var openAiKey = ""
    @AppStorage(AIServerDefaultsKeys.maxHistory) private var maxHistory = 6
    @AppStorage(AIServerDefaultsKeys.systemMessage) private var systemMessage = ""
    @AppStorage(AIServerDefaultsKeys.useSystemMessage) private var useSystemMessage = false

    var body: some View {
        Form {
            Section("AI Server") {
                TextField(
                    "API key",
                    text: $openAiKey
                )
                Slider(
                    value: $temperature,
                    in: 0...2,
                    step: 0.1
                ) {
                    Text("Temperature \(temperature)")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("2")
                }
                Picker("Model", selection: $aiModel) {
                    ForEach(GPTModels.models, id: \.self) { model in
                        Text(model)
                            .tag(model)
                    }
                }
                Picker("Maximum history to send", selection: $maxHistory) {
                    ForEach(Array(stride(from: 0, to: 67, by: 6)), id: \.self) { number in
                        Text(formatHistoryPickerValue(for: number))
                            .tag(number)
                    }
                }
                TextField(
                    "System message",
                    text: $systemMessage
                )
                Toggle("System message enabled", isOn: $useSystemMessage)
            }
        }
    }

    private func formatHistoryPickerValue(for number: Int) -> String {
        "\(number == 0 ? "No limit" : number.formatted())"
    }
}

#Preview {
    SettingsView()
}
