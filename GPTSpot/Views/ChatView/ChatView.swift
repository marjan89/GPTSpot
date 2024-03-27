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
    
    enum FocusedMessageField : Hashable {
        case index(_ value: Int)
    }
    
    @Bindable var chatViewService: ChatViewService
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \ChatMessage.timestamp, order: .reverse) var chatMessages: [ChatMessage]
    
    @FocusState private var focusedField: FocusedField?
    
    @AppStorage(AIServerDefaultsKeys.maxHistory) var maxHistory = 6
    @AppStorage(AIServerDefaultsKeys.aiModel) var aiModel = "Not defined"
    @AppStorage(GeneralSettingsDefaultsKeys.showHelpRibbon) var showHelpRibbon = true
    @AppStorage(GeneralSettingsDefaultsKeys.showStats) var showStats = true
    
    @FocusState var focusedMessageField: FocusedMessageField?
    
    var body: some View {
        ZStack {
            HotkeyAction(hotkey: .return) {
                chatViewService.executePrompt()
            }
            HotkeyAction(hotkey: .return, eventModifiers: [.command,.shift]) {
                chatViewService.executePrompt(shouldDiscardHistory: true)
            }
            HotkeyAction(hotkey: .init("d")) {
                chatViewService.discardHistory()
            }
            HotkeyAction(hotkey: .upArrow) {
                chatViewService.setToLastUserPrompt()
            }
            HotkeyAction(hotkey: .init("?")) {
                showHelpRibbon = !showHelpRibbon
            }
            HotkeyAction(hotkey: .init(".")) {
                showStats = !showStats
            }
            HotkeyAction(hotkey: .init("t")) {
                chatViewService.showTemplateStripe = !chatViewService.showTemplateStripe
            }
            HotkeyAction(hotkey: .init("k")) {
                if case let .index(value) = focusedMessageField {
                    focusedMessageField = .index(min(value + 1, chatMessages.count - 1))
                } else {
                    focusedMessageField = .index(0)
                }
            }
            HotkeyAction(hotkey: .init("j")) {
                if case let .index(value) = focusedMessageField {
                    focusedMessageField = .index(max(value - 1, 0))
                } else {
                    focusedMessageField = .index(0)
                }
            }
            HotkeyAction(hotkey: .return, eventModifiers: .option) {
                if case let .index(value) = focusedMessageField {
                    chatViewService.prompt = chatMessages[value].content
                }
            }
            HotkeyAction(hotkey: .delete) {
                if case let .index(value) = focusedMessageField {
                    chatViewService.deleteMessage(chatMessages[value])
                }
            }
            HotkeyAction(hotkey: .init("s")) {
                if case let .index(value) = focusedMessageField {
                    chatViewService.insertTemplate(from: chatMessages[value])
                }
            }
            HotkeyAction(hotkey: .init("c")) {
                if case let .index(value) = focusedMessageField {
                    copyTextToClipboard(text: chatMessages[value].content)
                }
            }
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        List {
                            ForEach(chatMessages.indices, id: \.self) { index in
                                let chatMessage = chatMessages[index]
                                ChatMessageView(
                                    chatMessage: chatMessage,
                                    spacerWidth: geometry.size.width * 0.33
                                )
                                .focusable(true)
                                .focused($focusedMessageField, equals: .index(index))
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
                                        chatViewService.deleteMessage(chatMessage)
                                    } label: {
                                        Text("Delete")
                                    }
                                    Button {
                                        chatViewService.insertTemplate(from: chatMessage)
                                    } label: {
                                        Text("Save template")
                                    }
                                }))
                                .padding(.bottom, 4)
                                .listRowSeparator(.hidden)
                                .scaleEffect(x: 1, y: -1, anchor: .center)
                                .id(index)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                        VStack {
                            if chatViewService.showTemplateStripe {
                                TemplateStripeView(searchQuery: chatViewService.templateSearchQuery)
                                    .environment(chatViewService)
                                    .frame(height: 196)
                            }
                            TextEditor(text: chatViewService.showTemplateStripe ? $chatViewService.templateSearchQuery : $chatViewService.prompt)
                                .padding(.all, 8)
                                .scrollClipDisabled()
                                .scrollContentBackground(.hidden)
                                .scrollIndicators(.never)
                                .focused($focusedField, equals: .prompt)
                                .onAppear { focusedField = .prompt }
                                .roundCorners(strokeColor: .gray)
                                .frame(height: geometry.size.height / 8)
                                .padding(.top, 4)
                            HStack {
                                Spacer()
                                Button("", systemImage: "questionmark.circle.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "chart.bar.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "trash.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "folder.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "memories") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "paperplane.circle.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                                Button("", systemImage: "paperplane.fill") {}
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            if showHelpRibbon {
                                CheatSheetView()
                                    .padding(.top, 4)
                            }
                            if showStats {
                                HStack {
                                    Text("total history: **\(chatMessages.count)**")
                                    Text("history max: **\(maxHistory)**")
                                    Text("**\(aiModel)**")
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .padding(.top, 8)
                    }
                }
                .background(.windowBackground)
                .roundCorners(radius: 16, strokeColor: Color.black)
            }
            .padding(.all, 20)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.33), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
    
    func copyTextToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
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
        
        return ChatView(chatViewService: .init(
            modelContext: previewer.container.mainContext,
            openAISerice: OpenAIServiceKey.defaultValue)
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
