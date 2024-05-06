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
    @Environment(\.modelContext) private var modelContext: ModelContext
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
            sort: \ChatMessage.timestamp
        )
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { chatMessage in
                            ChatMessageView(
                                chatMessage: chatMessage,
                                maxMessageWidth: geometry.size.width * 0.66
                            )
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Copy", systemImage: "doc.on.doc.fill") {
                                    chatMessage.content.copyTextToClipboard()
                                }
                                Button("Make prompt", systemImage: "return") {
                                    chatViewService.prompt = chatMessage.content
                                }
                                Button("Delete", systemImage: "trash.fill") {
                                    modelContext.delete(chatMessage)
                                }
                                Button("Save template", systemImage: "square.and.arrow.down.fill") {
                                    modelContext.insert(Template(content: chatMessage.content))
                                }
                            }))
                        }
                        .padding(8)
                    }
                }
                .defaultScrollAnchor(.bottom)
                .scrollClipDisabled()
                .scrollDismissesKeyboard(.immediately)
            }
            HStack {
                Button("", systemImage: "folder.fill") {

                }
                .accessibilityLabel("Show templates")
                HStack {
                    TextField("text", text: $chatViewService.prompt)
                        .padding(8)
                        .padding(.horizontal, 8)
                    Button(
                        "",
                        systemImage: chatViewService.generatingContent ? "stop.fill" : "arrow.up.circle.fill"
                    ) {
                        if chatViewService.generatingContent {
                            chatViewService.cancelCompletion()
                        } else {
                            chatViewService.executePrompt(workspace: workspace)
                        }
                    }
                    .accessibilityLabel("Send")
                }
                .roundedCorners(radius: 24, stroke: 1, strokeColor: Color.gray)
            }
            .padding(16)
            .background(.regularMaterial)
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
