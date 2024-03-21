//
//  ContentView.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import SwiftUI

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
