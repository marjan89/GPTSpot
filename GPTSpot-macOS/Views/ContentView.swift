//
//  ContentView.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import SwiftUI
import GPTSpot_Common

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.openAIService) var openAIService

    var body: some View {
        ChatView()
            .environment(
                ChatViewService(
                    modelContext: modelContext,
                    openAISerice: openAIService
                )
            )
            .environment(TemplateStripeService(modelContext: modelContext))
    }
}

#Preview {
    ContentView()
}
