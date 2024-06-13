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
        WorkspaceHomeView()
            .environment(ChatViewService(modelContext: modelContext, openAISerice: openAIService))
            .environment(WorkspaceHomeService(modelContext: modelContext))
            .environment(ChatMessageService(modelContext: modelContext))
            .environment(TemplateService(modelContext: modelContext))
    }
}

#Preview {
    ContentView()
}
