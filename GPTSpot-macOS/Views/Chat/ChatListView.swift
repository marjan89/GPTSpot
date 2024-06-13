//
//  ChatListView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/3/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

enum FocusedMessageField: Hashable {
    case focusedMessage(_ chatMessage: ChatMessage)
}

struct ChatListView: View {

    @FocusState private var focusedMessageField: FocusedMessageField?
    @Environment(ChatViewService.self) private var chatViewService: ChatViewService
    @Environment(ChatMessageService.self) private var chatMessageService: ChatMessageService
    @Environment(TemplateService.self) private var templateService: TemplateService

    @Query private var chatMessages: [ChatMessage]
    @Binding private var prompt: String
    private let workspace: Int

    init(workspace: Int, prompt: Binding<String>) {
        self.workspace = workspace
        self._prompt = prompt
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { chatMessage in
                chatMessage.workspace == workspace && !(chatMessage.origin == "system")
            },
            sort: \ChatMessage.timestamp
        )
    }

    var body: some View {
        ZStack {
//            hotkeys()
            ScrollViewReader { proxy in
                GeometryReader { geometry in
                    List(chatMessages, id: \.id) { chatMessage in
                        ChatMessageView(
                            chatMessage: chatMessage,
                            maxMessageWidth: geometry.size.width * 0.66
                        )
                        .focusable(true)
                        .focused($focusedMessageField, equals: .focusedMessage(chatMessage))
                        .contextMenu(ContextMenu(menuItems: {
                            Button {
                                chatMessage.content.copyTextToClipboard()
                            } label: {
                                Text("Copy")
                            }
                            .keyboardShortcut("c", modifiers: .option)
                            Button {
                                prompt = chatMessage.content
                            } label: {
                                Text("Make prompt")
                            }
                            .keyboardShortcut(.return, modifiers: .option)
                            Button {
                                chatMessageService.deleteChatMessage(chatMessage)
                            } label: {
                                Text("Delete")
                            }
                            .keyboardShortcut(.delete, modifiers: .option)
                            Button {
                                templateService.insertTemplate(Template(content: chatMessage.content))
                            } label: {
                                Text("Save template")
                            }
                            .keyboardShortcut("s", modifiers: .option)
                        }))
                        .listRowInsets(.init(top: 16, leading: 0, bottom: 0, trailing: 0))
                        .padding(.bottom, 8)
                        .listRowSeparator(.hidden)
                    }
                    .onChange(of: focusedMessageField) {
                        if case let .focusedMessage(chatMessage) = focusedMessageField {
                            proxy.scrollTo(chatMessage.id)
                        }
                    }
                    .onChange(of: chatMessages) {
                        if let lastChatMessage = chatMessages.last {
                            proxy.scrollTo(lastChatMessage.id)
                        }
                    }
                    .onAppear {
                        if let lastChatMessage = chatMessages.last {
                            proxy.scrollTo(lastChatMessage.id)
                        }
                    }
                    .listStyle(.plain)
                    .scrollClipDisabled()
                }
            }
        }
    }

    @ViewBuilder
    private func hotkeys() -> some View {
        HotkeyAction(hotkey: .init("k")) {
            focusMessage(.next)
        }
        HotkeyAction(hotkey: .init("j")) {
            focusMessage(.previous)
        }
        HotkeyAction(hotkey: .return, eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                prompt = chatMessage.content
            }
        }
        HotkeyAction(hotkey: .delete, eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                chatMessageService.deleteChatMessage(chatMessage)
            }
        }
        HotkeyAction(hotkey: .init("s"), eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                templateService.deleteTemplate(Template(content: chatMessage.content))
            }
        }
        HotkeyAction(hotkey: .init("c"), eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                chatMessage.content.copyTextToClipboard()
            }
        }
    }

    private func focusMessage(_ direction: FocusDirection) {
        if case let .focusedMessage(focusedMessage) = focusedMessageField {
            let index = chatMessages.firstIndex(of: focusedMessage) ?? chatMessages.count - 1
            let newMessageIndex = switch direction {
            case .next:
                min(index + 1, chatMessages.count - 1)
            case .previous:
                max(index - 1, 0)
            }
            focusedMessageField = .focusedMessage(chatMessages[newMessageIndex])
        } else if let chatMessage = chatMessages.first {
            focusedMessageField = .focusedMessage(chatMessage)
        }
    }
}

#Preview {

    do {
        let previewer = try Previewer()
        @State var prompt: String = ""

        return ChatListView(
            workspace: 1,
            prompt: $prompt
        )
        .environment(previewer.chatViewService)
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
