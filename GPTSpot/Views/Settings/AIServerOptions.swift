//
//  AIServerOptions.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation
import SwiftUI

struct AIServerOptions: View {
    
    @AppStorage("aiModel") private var aiModel = "gpt-4-0125-preview"
    @AppStorage("temperature") private var temperature = 0.5
    @AppStorage("openAIKey") private var openAiKey = ""
    @AppStorage("maxHistory") private var maxHistory = 6
    
    var body: some View {
        Form {
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
                Text("gpt-4-1106-preview")
                    .tag("gpt-4-1106-preview")
                Text("gpt-4-0125-preview")
                    .tag("gpt-4-0125-preview")
            }
            TextField(
                "Maximum history to send",
                value: $maxHistory,
                formatter: NumberFormatter()
            )
        }
        .padding(20)
        .frame(width: 500, height: 150)
    }
}
