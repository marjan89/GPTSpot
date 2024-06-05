//
//  WorkspaceItemView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct WorkspaceItemView: View {

    @Query private var lastChatMessage: [ChatMessage]
    private let workspaceIndex: Int

    init(workspaceIndex: Int) {
        self.workspaceIndex = workspaceIndex
        var lastChatMessagesFetchDescriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate<ChatMessage> { message in
                message.origin != "user" && message.workspace == workspaceIndex
            },
            sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
        )
        lastChatMessagesFetchDescriptor.fetchLimit = 1
        _lastChatMessage = Query(lastChatMessagesFetchDescriptor)
    }

    var body: some View {
        HStack {
            ZStack {
                Color(.blue)
                    .frame(width: 50, height: 50)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .imageScale(.medium)
                Text("⌘\(workspaceIndex)")
                    .fontWeight(.bold)
                    .font(.headline)
            }
            Text(lastChatMessage.first?.content ?? "")
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return WorkspaceItemView(workspaceIndex: 2)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
