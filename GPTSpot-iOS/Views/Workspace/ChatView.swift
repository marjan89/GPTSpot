//
//  ChatView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(ChatViewService.self) private var chatViewService: ChatViewService
    @Query private var chatMessages: [ChatMessage]
    @Query private var templates: [Template]
    @AppStorage(AIServerDefaultsKeys.usePrompPrefix) private var promptPrefix: Bool = false
    @AppStorage(IOSDefaultsKeys.expandedInputField) private var expandedInputField: Bool = false
    @State private var promptPrefixSheetShown = false
    @State private var prompt = ""

    private let workspace: Int

    init(workspace: Int) {
        self.workspace = workspace
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { chatMessage in
                chatMessage.workspace == workspace
            },
            sort: \ChatMessage.timestamp
        )
    }

    var body: some View {
        chatList()
        HStack {
            NavigationLink {
                TemplateList { template in
                    prompt.append(template.content)
                }
            } label: {
                Image(systemName: "folder.fill")
            }
            Button("", systemImage: "text.quote") {
                promptPrefixSheetShown.toggle()
            }
            .sheet(isPresented: $promptPrefixSheetShown) {
                promptPrefixSheet()
            }
            .accessibilityLabel("Prompt prefix")
            .help("Prompt prefix")
            .toggleStyle(.button)
            promptInput()
        }
        .padding(16)
        .background(.regularMaterial)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Workspace ⌘\(workspace)")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(
                    "",
                    systemImage: expandedInputField ? "rectangle.compress.vertical" : "rectangle.expand.vertical"
                ) {
                    expandedInputField.toggle()
                }
                Button("", systemImage: "trash.fill") {
                    chatViewService.discardHistory(for: workspace)
                }
            }
        }
    }

    @ViewBuilder
    private func chatList() -> some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geomatry in
                List(chatMessages, id: \.self) { chatMessage in
                    ChatMessageView(
                        chatMessage: chatMessage,
                        maxMessageWidth: geomatry.size.width * 0.66
                    )
                    .listRowInsets(.none)
                    .listRowSeparator(.hidden)
                    .id(chatMessage)
                    .padding(.horizontal, 8)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Copy", systemImage: "doc.on.doc.fill") {
                            chatMessage.content.copyTextToClipboard()
                        }
                        Button("Make prompt", systemImage: "return") {
                            prompt = chatMessage.content
                        }
                        Button("Delete", systemImage: "trash.fill") {
                            modelContext.delete(chatMessage)
                        }
                        Button("Save template", systemImage: "square.and.arrow.down.fill") {
                            modelContext.insert(Template(content: chatMessage.content))
                        }
                    }))
                }
                .listStyle(.plain)
                .scrollClipDisabled()
                .scrollDismissesKeyboard(.immediately)
                .onAppear {
                    scrollProxy.scrollTo(chatMessages.last, anchor: .bottom)
                }
                .onChange(of: chatMessages) {
                    scrollProxy.scrollTo(chatMessages.last, anchor: .bottom)
                }
            }
        }
    }

    @ViewBuilder
    private func promptInput() -> some View {
        HStack {
            if expandedInputField {
                TextEditor(text: $prompt)
                    .padding(8)
                    .padding(.horizontal, 8)
                    .accessibilityHidden(true)
                    .scrollClipDisabled()
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)
                    .frame(height: UIScreen.main.bounds.height * 0.2)
            } else {
                TextField("Send a message", text: $prompt)
                    .padding(8)
                    .padding(.horizontal, 8)
            }
            Button(
                "",
                systemImage: chatViewService.generatingContent ? "stop.fill" : "arrow.up.circle.fill"
            ) {
                if chatViewService.generatingContent {
                    chatViewService.cancelCompletion()
                } else {
                    chatViewService.executePrompt(workspace: workspace, prompt: prompt)
                    prompt = ""
                }
            }
            .accessibilityLabel("Send")
            .help("Send")
        }
        .roundedCorners(radius: 24, stroke: 1, strokeColor: Color.gray)
    }

    @ViewBuilder
    private func promptPrefixSheet() -> some View {
        VStack {
            Form {
                Section {
                    if !prompt.isEmpty {
                        Button("Save prompt as template", systemImage: "square.and.arrow.down.fill") {
                            chatViewService.savePrompAsTemplate(prompt)
                        }
                        .accessibilityLabel("Save template")
                        .help("Save template")
                    }
                    Toggle(
                        isOn: $promptPrefix,
                        label: {
                            Text("Prompt prefix")
                        }
                    )
                }
            }
            Button("Dismiss") {
                promptPrefixSheetShown.toggle()
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ChatView( workspace: 1 )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
