//
//  GPTSpot_iOSApp.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common

@main
struct GPTSpotiOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ChatMessage.self, Template.self])
                .environment(\.openAIService, OpenAIServiceKey.defaultValue)
        }
    }
}
