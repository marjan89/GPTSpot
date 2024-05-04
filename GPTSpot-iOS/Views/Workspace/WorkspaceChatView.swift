//
//  ChatView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct WorkspaceChatView: View {
    @Bindable var chatViewService: ChatViewService
    @Query private var chatMessages: [ChatMessage]
    private var workspace: Int

    init(chatViewService: ChatViewService, workspace: Int) {
        self.chatViewService = chatViewService
        self.workspace = workspace
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { chatMessage in
                chatMessage.workspace == workspace
            },
            sort: \ChatMessage.timestamp,
            order: .reverse
        )
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages) { chatMessage in
                        Text(chatMessage.content)
                    }
                }
            }
            HStack {
                Button("", systemImage: "folder.fill") {

                }
                .accessibilityLabel("Show templates")
                HStack {
                    TextField("text", text: $chatViewService.prompt)
                        .padding(8)
                        .padding(.horizontal, 8)
                    Button("", systemImage: "arrow.up.circle.fill") {

                    }
                    .accessibilityLabel("Send")
                }
                .roundedCorners(radius: 124, stroke: 1, strokeColor: Color.gray)
            }
            .padding(8)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return WorkspaceChatView(
            chatViewService: .init(
                modelContext: previewer.container.mainContext,
                openAISerice: OpenAIServiceKey.defaultValue
            ),
            workspace: 1
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
