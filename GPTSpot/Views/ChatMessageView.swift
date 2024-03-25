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
    @Environment(ChatViewService.self) var chatViewService
    
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
                menu()
            }
            Markdown(chatMessage.content)
                .markdownBlockStyle(\.codeBlock) { configuration in
                    configuration.label
                        .relativeLineSpacing(.em(0.25))
                        .markdownTextStyle {
                            FontFamilyVariant(.monospaced)
                            FontSize(.em(0.85))
                            FontWeight(.bold)
                        }
                        .padding()
                        .background(backgroundColorMarkdown())
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .markdownMargin(top: .zero, bottom: .em(0.8))
                }
                .markdownTextStyle(\.code) {
                    FontFamilyVariant(.monospaced)
                    FontWeight(.bold)
                    BackgroundColor(backgroundColorMarkdown())
                }
                .foregroundColor(Color(.textColor))
                .textSelection(.enabled)
                .scrollContentBackground(.hidden)
                .padding(.all, 8)
                .background(backgroundColor())
                .roundCorners(radius: 8)
                .frame(alignment: chatMessage.origin == Role.user.rawValue ? .trailing : .leading)
                .layoutPriority(1)
            if chatMessage.origin == Role.assistant.rawValue {
                menu()
                Spacer()
                    .frame(maxWidth: spacerWidth)
                    .layoutPriority(2)
            }
        }
    }
    
    private func backgroundColor() -> Color {
        chatMessage.origin == Role.user.rawValue ? Color.blue : Color(.unemphasizedSelectedTextBackgroundColor)
    }
    
    private func backgroundColorMarkdown() -> Color {
        Color.black.opacity(0.2)
    }
    
    private func menu() -> some View {
        VStack {
            Spacer()
            Image(systemName: "ellipsis.circle")
                .contextMenu(ContextMenu(menuItems: {
                    Button {
                        copyTextToClipboard(text: chatMessage.content)
                    } label: {
                        Text("Copy")
                    }
                    Button {
                        chatViewService.prompt = chatMessage.content
                    } label: {
                        Text("Make prompt")
                    }
                    Button {
                        chatViewService.deleteMessage(for: chatMessage)
                    } label: {
                        Text("Delete")
                    }
                }))
                .padding(.bottom, 4)
        }
    }
    
    func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
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
