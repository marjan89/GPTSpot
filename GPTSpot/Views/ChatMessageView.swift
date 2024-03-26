//
//  ChatMessageView.swift
//  GPTSpot
//
//  Created by Sinisa on 27.2.24..
//

import SwiftUI
import MarkdownUI

struct ChatMessageView: View {
    
    @Environment(\.modelContext) var modelContext
    
    let chatMessage: ChatMessage
    let spacerWidth: Double
    
    init(chatMessage: ChatMessage, spacerWidth: Double) {
        self.chatMessage = chatMessage
        self.spacerWidth = spacerWidth
    }
    
    var body: some View {
        HStack {
            if chatMessage.origin == Role.user.rawValue {
                Spacer()
                    .frame(minWidth: spacerWidth)
            }
            Markdown(chatMessage.content)
                .gptStyle()
                .padding(.all, 8)
                .background(backgroundColor())
                .roundCorners(radius: 8)
                .frame(alignment: chatMessage.origin == Role.user.rawValue ? .trailing : .leading)
                .layoutPriority(1)
                .textSelection(.enabled)
                .scrollContentBackground(.hidden)
            if chatMessage.origin == Role.assistant.rawValue {
                Spacer()
                    .frame(maxWidth: spacerWidth)
                    .layoutPriority(2)
            }
        }
    }
    
    private func backgroundColor() -> Color {
        chatMessage.origin == Role.user.rawValue ? Color.blue : Color(.unemphasizedSelectedTextBackgroundColor)
    }
    
    #Preview {
        ChatMessageView(
            chatMessage: ChatMessage(
                content: "Hello world",
                origin: Role.user.rawValue,
                timestamp: 0,
                id: ""
            ),
            spacerWidth: 100
        )
    }
}
