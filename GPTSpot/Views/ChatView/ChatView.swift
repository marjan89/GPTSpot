//
//  ChatView.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import SwiftUI
import SwiftData

struct ChatView: View {
    
    enum FocusedField {
        case prompt
    }
    
    @Bindable var chatViewService: ChatViewService
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ChatMessage.timestamp, order: .reverse) var chatMessages: [ChatMessage]
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            HotkeyAction(hotkey: .return, eventModifiers: .command) {
                chatViewService.executePrompt()
            }
            HotkeyAction(hotkey: .return, eventModifiers: [.command,.shift]) {
                chatViewService.executePrompt(shouldDiscardHistory: true)
            }
            HotkeyAction(hotkey: KeyEquivalent("d"), eventModifiers: .command) {
                chatViewService.discardHistory()
            }
            HotkeyAction(hotkey: .upArrow, eventModifiers: .command) {
                chatViewService.setToLastUserPrompt()
            }
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        ScrollViewReader { scrollView in
                            List {
                                ForEach(chatMessages) { chatMessage in
                                    if let role = Role(rawValue: chatMessage.origin) {
                                        ChatMessageView(
                                            content: chatMessage.content,
                                            origin: role,
                                            spacerWidth: geometry.size.width * 0.33
                                        )
                                        .listRowSeparator(.hidden)
                                        .scaleEffect(x: 1, y: -1, anchor: .center)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .scaleEffect(x: 1, y: -1, anchor: .center)
                        }
                        ZStack {
                            VStack {
                                TextEditor(text: $chatViewService.prompt)
                                    .padding(.all, 8)
                                    .scrollClipDisabled()
                                    .scrollContentBackground(.hidden)
                                    .scrollIndicators(.never)
                                    .focused($focusedField, equals: .prompt)
                                    .onAppear { focusedField = .prompt }
                                    .roundCorners(strokeColor: .gray)
                                    .frame(height: geometry.size.height / 8)
                                HStack {
                                    Text("**⌘d** discard history")
                                    Text("**⌘↑** last prompt")
                                    Text("**⌘↩** send")
                                    Text("**⌘⇧↩** discard history and send")
                                    Text("**⇧⌃Space** show/hide")
                                }
                                .padding(.top, 4)
                                Text("\(chatMessages.count) messages in history")
                                    .padding(.top, 4)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .background(.windowBackground)
                .roundCorners(strokeColor: Color.black)
            }
            .padding(.all, 20)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.33), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
    
    private func scrollMessageListToBottom(for scrollView: ScrollViewProxy) {
        if chatMessages.count > 0 {
            scrollView.scrollTo(chatMessages[chatMessages.endIndex - 1].id, anchor: .bottom)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ChatView(chatViewService: .init(modelContext: previewer.container.mainContext))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
