//
//  ChatListView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 7/6/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct ChatListView<ContextMenuItems: View>: View {
    @Query private var chatMessages: [ChatMessage]
    @ViewBuilder private let contextMenuItems: (ChatMessage) -> ContextMenuItems

    init(workspace: Int, contextMenuItems: @escaping (ChatMessage) -> ContextMenuItems) {
        self.contextMenuItems = contextMenuItems
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { chatMessage in
                chatMessage.workspace == workspace && !(chatMessage.origin == "system")
            },
            sort: \ChatMessage.timestamp
        )
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geomatry in
                List(chatMessages, id: \.content) { chatMessage in
                    ChatListItemView(
                        chatMessage: chatMessage,
                        maxMessageWidth: geomatry.size.width * 0.66
                    )
                    .listRowInsets(.none)
                    .listRowSeparator(.hidden)
                    .id(chatMessage)
                    .padding(.horizontal, 8)
                    .contextMenu(ContextMenu(menuItems: {
                        contextMenuItems(chatMessage)
                    }))
                }
                .listStyle(.plain)
                .scrollClipDisabled()
                .scrollDismissesKeyboard(.immediately)
                .onAppear {
                    scrollProxy.scrollTo(chatMessages.last?.content, anchor: .bottom)
                }
                .onChange(of: chatMessages) {
                    scrollProxy.scrollTo(chatMessages.last?.content, anchor: .bottom)
                }
            }
        }
    }
}

#Preview {
    Previewer {
        ChatListView(
            workspace: 1,
            contextMenuItems: { _ in
                EmptyView()
            }
        )
    }
}
