//
//  ContentView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common

struct ContentView: View {

    @Environment(\.modelContext) var modelContext
    @Environment(\.openAIService) var openAIService

    var body: some View {
        ChatView(chatViewService: .init(
            modelContext: modelContext,
            openAISerice: openAIService)
        )
    }
}

#Preview {
    ContentView()
}
