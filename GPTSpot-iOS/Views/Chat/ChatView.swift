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
    @Environment(ChatViewService.self) private var chatViewService: ChatViewService
    @Query private var templates: [Template]
    @AppStorage(AIServerDefaultsKeys.usePrompPrefix) private var promptPrefix: Bool = false
    @AppStorage(IOSDefaultsKeys.expandedInputField) private var expandedInputField: Bool = false
    @State private var promptPrefixSheetShown = false
    @State private var prompt = ""

    private let workspace: Int

    init(workspace: Int) {
        self.workspace = workspace
    }

    var body: some View {
        ChatListView(
            workspace: workspace,
            contextMenuItems: { chatMessage in
                contextMenuItems(chatMessage: chatMessage)
            }
        )
        HStack {
            templateList()
            chatOptions()
            promptInput()
        }
        .padding(16)
        .background(.regularMaterial)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Workspace ⌘\(workspace)")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                toolbar()
            }
        }
    }

    @ViewBuilder
    func contextMenuItems(chatMessage: ChatMessage) -> some View {
        Button("Copy", systemImage: "doc.on.doc.fill") {
            chatMessage.content.copyTextToClipboard()
        }
        Button("Make prompt", systemImage: "return") {
            prompt = chatMessage.content
        }
        Button("Delete", systemImage: "trash.fill") {
            chatViewService.deleteChatMessage(chatMessage)
        }
        Button("Save template", systemImage: "square.and.arrow.down.fill") {
            chatViewService.insertTemplate(Template(content: chatMessage.content))
        }
    }

    @ViewBuilder
    private func toolbar() -> some View {
        Button {
            expandedInputField.toggle()
        } label: {
            Image(systemName: expandedInputField ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
        }
        Button {
            chatViewService.discardHistory(for: workspace)
        } label: {
            Image(systemName: "trash.fill")
        }
    }

    @ViewBuilder
    private func templateList() -> some View {
        NavigationLink {
            TemplateList(
                onTemplateSelected: { template in
                    prompt.append(template.content)
                },
                onTemplateSwipeDelete: { template in
                    chatViewService.deleteTemplate(template)
                }
            )
        } label: {
            Image(systemName: "folder.fill")
        }
    }

    @ViewBuilder
    private func chatOptions() -> some View {
        Button {
            promptPrefixSheetShown.toggle()
        } label: {
            Image(systemName: "text.quote")
        }
        .sheet(isPresented: $promptPrefixSheetShown) {
            promptPrefixSheet()
        }
        .accessibilityLabel("Prompt prefix")
        .help("Prompt prefix")
        .toggleStyle(.button)
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
            Button {
                if chatViewService.generatingContent {
                    chatViewService.cancelCompletion()
                } else {
                    chatViewService.executePrompt(workspace: workspace, prompt: prompt)
                    prompt = ""
                }
            } label: {
                Image(systemName: chatViewService.generatingContent ? "stop.fill" : "arrow.up.circle.fill")
            }
            .padding(.trailing, 8)
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
                        .keyboardShortcut("s")
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
            .environment(previewer.chatViewService)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
