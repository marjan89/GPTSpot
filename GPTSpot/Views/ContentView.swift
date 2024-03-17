//
//  ContentView.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    var body: some View {
        ChatView(chatViewService: .init(modelContext: modelContext))
    }
}

#Preview {
    ContentView()
}
