//
//  ChatMessageView.swift
//  GPTSpot
//
//  Created by Sinisa on 27.2.24..
//

import SwiftUI
import MarkdownUI
import GPTSpot_Common

public struct ChatListItemView: View {

    private let chatMessage: ChatMessage
    private let maxMessageWidth: Double

    public init(chatMessage: ChatMessage, maxMessageWidth: Double) {
        self.chatMessage = chatMessage
        self.maxMessageWidth = maxMessageWidth
    }

    public var body: some View {
        HStack {
            Markdown(chatMessage.content)
                .markdownCopyActionStyle()
                .padding(.all, 8)
                .background(backgroundColor())
                .cornerRadius(8)
                .textSelection(.enabled)
                .frame(
                    maxWidth: maxMessageWidth,
                    alignment: chatMessage.origin == Role.user.rawValue ? .trailing : .leading
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: chatMessage.origin == Role.user.rawValue ? .trailing : .leading
        )
    }

    private func backgroundColor() -> Color {
        chatMessage.origin == Role.user.rawValue ? Color.blue : Color(.darkGray)
    }
}

#Preview {
    VStack {
        ChatListItemView(
            chatMessage: ChatMessage(
                content: "Hello",
                origin: Role.user.rawValue,
                timestamp: 1,
                id: "1",
                workspace: 1
            ),
            maxMessageWidth: 200
        )
        ChatListItemView(
            chatMessage: ChatMessage(
                content: "Hi!",
                origin: Role.assistant.rawValue,
                timestamp: 2,
                id: "2",
                workspace: 1
            ),
            maxMessageWidth: 200
        )
        ChatListItemView(
            chatMessage: ChatMessage(
                content: "Response error",
                origin: Role.local.rawValue,
                timestamp: 3,
                id: "3",
                workspace: 1
            ),
            maxMessageWidth: 200
        )
        ChatListItemView(
            chatMessage: ChatMessage(
                content: "System message",
                origin: Role.system.rawValue,
                timestamp: 3,
                id: "4",
                workspace: 1
            ),
            maxMessageWidth: 200
        )
    }
}
