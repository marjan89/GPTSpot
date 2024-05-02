//
//  ChatListView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/3/24.
//

import SwiftUI
import SwiftData

enum FocusedMessageField : Hashable {
    case focusedMessage(_ chatMessage: ChatMessage)
}

struct ChatListView: View {
    
    @FocusState var focusedMessageField: FocusedMessageField?
    
    @Environment(\.modelContext) var modelContext: ModelContext
    
    @Query var chatMessages: [ChatMessage]
    
    @Binding var prompt: String
    
    private let workspace: Int
    
    init(workspace: Int, prompt: Binding<String>) {
        self.workspace = workspace
        self._prompt = prompt
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { chatMessage in
                chatMessage.workspace == workspace
            },
            sort: \ChatMessage.timestamp,
            order: .reverse
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack{
                    List {
                        ForEach(chatMessages, id: \.id ) { chatMessage in
                            ChatMessageView(
                                chatMessage: chatMessage,
                                spacerWidth: geometry.size.width * 0.33
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
                                    modelContext.delete(chatMessage)
                                } label: {
                                    Text("Delete")
                                }
                                .keyboardShortcut(.delete, modifiers: .option)
                                Button {
                                    modelContext.insert(Template(content: chatMessage.content))
                                } label: {
                                    Text("Save template")
                                }
                                .keyboardShortcut("s", modifiers: .option)
                            }))
                            .listRowSeparator(.hidden)
                            .scaleEffect(x: 1, y: -1, anchor: .center)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                    hotkeys(with: proxy)
                }
            }
        }
    }
    
    @ViewBuilder
    private func hotkeys(with scrollViewProxy: ScrollViewProxy) -> some View {
        HotkeyAction(hotkey: .init("k")) {
            focusMessage(.next, scrollViewProxy)
        }
        HotkeyAction(hotkey: .init("j")) {
            focusMessage(.previous, scrollViewProxy)
        }
        HotkeyAction(hotkey: .return, eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                prompt = chatMessage.content
            }
        }
        HotkeyAction(hotkey: .delete, eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                modelContext.delete(chatMessage)
            }
        }
        HotkeyAction(hotkey: .init("s"), eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                modelContext.insert(Template(content: chatMessage.content))
            }
        }
        HotkeyAction(hotkey: .init("c"), eventModifiers: .option) {
            if case let .focusedMessage(chatMessage) = focusedMessageField {
                chatMessage.content.copyTextToClipboard()
            }
        }
    }
    
    private func focusMessage(_ direction: FocusDirection, _ scrollViewProxy: ScrollViewProxy) {
        if case let .focusedMessage(focusedMessage) = focusedMessageField {
            let index = chatMessages.firstIndex(of: focusedMessage) ?? 0
            let newMessageIndex = switch direction {
            case .next:
                min(index + 1, chatMessages.count - 1)
            case .previous:
                max(index - 1, 0)
            }
            focusedMessageField = .focusedMessage(chatMessages[newMessageIndex])
            scrollViewProxy.scrollTo(chatMessages[newMessageIndex].id)
        } else if let chatMessage = chatMessages.first  {
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
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
    
}
