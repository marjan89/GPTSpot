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
    @Query private var templates: [Template]
    @AppStorage(AIServerDefaultsKeys.usePrompPrefix) private var promptPrefix: Bool = false
    @AppStorage(IOSDefaultsKeys.expandedInputField) private var expandedInputField: Bool = false
    @State private var promptPrefixSheetShown = false
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
        GeometryReader { geomatry in
            ScrollView(.vertical) {
                ForEach(chatMessages, id: \.id) { chatMessage in
                    ChatMessageView(
                        chatMessage: chatMessage,
                        maxMessageWidth: geomatry.size.width * 0.66
                    )
                    .padding(.horizontal, 8)
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
                .frame(minHeight: geomatry.size.height, alignment: .bottom)
            }
            .defaultScrollAnchor(.bottom)
            .scrollClipDisabled()
            .scrollDismissesKeyboard(.immediately)
        }
        HStack {
            NavigationLink {
                TemplateList { template in
                    chatViewService.appendToPrompt(template.content)
                }
            } label: {
                Image(systemName: "folder.fill")
            }
            Button("", systemImage: "text.quote") {
                promptPrefixSheetShown.toggle()
            }
            .sheet(isPresented: $promptPrefixSheetShown) {
                VStack {
                    Form {
                        Section {
                            if !chatViewService.prompt.isEmpty {
                                Button("Save prompt as template", systemImage: "square.and.arrow.down.fill") {
                                    chatViewService.savePrompAsTemplate()
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
            .accessibilityLabel("Prompt prefix")
            .help("Prompt prefix")
            .toggleStyle(.button)
            HStack {
                if expandedInputField {
                    TextEditor(text: $chatViewService.prompt)
                        .padding(8)
                        .padding(.horizontal, 8)
                        .accessibilityHidden(true)
                        .scrollClipDisabled()
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .frame(height: UIScreen.main.bounds.height * 0.2)
                } else {
                    TextField("Send a message", text: $chatViewService.prompt)
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
                        chatViewService.executePrompt(workspace: workspace)
                    }
                }
                .accessibilityLabel("Send")
                .help("Send")
            }
            .roundedCorners(radius: 24, stroke: 1, strokeColor: Color.gray)
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
