//
//  ChatView.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct ChatView: View {

    @Environment(ChatViewService.self) private var chatViewService: ChatViewService
    @Environment(\.modelContext) private var modelContext

    @FocusState private var focusedField: Bool
    @AppStorage(AIServerDefaultsKeys.usePrompPrefix) private var promptPrefix: Bool = false

    @State var workspace = 1
    @State var showHelpRibbon = false
    @State var showStats = false
    @State var showTemplateStripe = false
    @State var templateSearchQuery = ""
    @State var prompt = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                ChatListView(
                    workspace: workspace,
                    prompt: $prompt
                )
                VStack {
                    templateStripe()
                    PromptEditor(
                        showTemplateHint: $showTemplateStripe,
                        templateSearchQuery: $templateSearchQuery,
                        prompt: $prompt,
                        focusedField: _focusedField,
                        textEditorHeight: geometry.size.height / 8
                    )
                    HStack {
                        WorkspaceIndicatorView(workspace: $workspace)
                        chatControls()
                    }
                    if showHelpRibbon {
                        CheatSheetView()
                    }
                    if showStats {
                        StatsView(workspace: workspace)
                    }
                }
                .padding(.all, 16)
                .background(.regularMaterial)
            }
        }
        .background(.windowBackground)
        .window()
    }

    @ViewBuilder
    func templateStripe() -> some View {
        if showTemplateStripe {
            TemplateStripeView(
                searchQuery: templateSearchQuery,
                onTemplateSelected: { template in
                    prompt.append(template.content)
                    focusedField = true
                    showTemplateStripe = false
                    templateSearchQuery = ""
                }
            )
            .frame(height: 196)
        }
    }

    @ViewBuilder
    func chatControls() -> some View {
        HStack {
            Spacer()
            saveAsTemplateButton()
            promptPrefixToggle()
            stopGeneratingContentButton()
            helpButton()
            statsButton()
            trashButton()
            templatesButton()
            lastMessageAsPrompt()
            sendButton()
        }
    }

    @ViewBuilder
    func saveAsTemplateButton() -> some View {
        if !prompt.isEmpty || !templateSearchQuery.isEmpty {
            Button("", systemImage: "square.and.arrow.down.fill") {
                if showTemplateStripe {
                    modelContext.insert(Template(content: templateSearchQuery))
                    templateSearchQuery = ""
                } else {
                    chatViewService.savePrompAsTemplate(prompt)
                }
            }
            .accessibilityLabel("Save as template")
            .help("Save as template")
            .keyboardShortcut(.init("s", modifiers: [.command]))
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    @ViewBuilder
    func promptPrefixToggle() -> some View {
        Toggle(
            isOn: $promptPrefix,
            label: {
                Text("Prompt prefix")
            }
        )
        .toggleStyle(SwitchToggleStyle())
        .keyboardShortcut(.init("/"))
    }

    @ViewBuilder
    func stopGeneratingContentButton() -> some View {
        if chatViewService.generatingContent {
            Button("", systemImage: "stop.fill") {
                chatViewService.cancelCompletion()
            }
            .accessibilityLabel("Cancel response")
            .help("Cancel response")
            .keyboardShortcut(.init(.return, modifiers: [.command, .shift]))
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    @ViewBuilder
    func helpButton() -> some View {
        Button("", systemImage: "questionmark.circle.fill") {
            showHelpRibbon.toggle()
        }
        .accessibilityLabel("Show help")
        .help("Show help")
        .keyboardShortcut(.init("?"))
        .buttonStyle(BorderlessButtonStyle())
    }

    @ViewBuilder
    func statsButton() -> some View {
        Button("", systemImage: "chart.bar.fill") {
            showStats.toggle()
        }
        .accessibilityLabel("Show stats")
        .help("Show stats")
        .keyboardShortcut(.init("."))
        .buttonStyle(BorderlessButtonStyle())
    }

    @ViewBuilder
    func trashButton() -> some View {
        Button("", systemImage: "trash.fill") {
            chatViewService.discardHistory(for: workspace)
        }
        .accessibilityLabel("Discard history")
        .help("Discard history")
        .keyboardShortcut(.init("d"))
        .buttonStyle(BorderlessButtonStyle())
    }

    @ViewBuilder
    func templatesButton() -> some View {
        Button("", systemImage: "folder.fill") {
            showTemplateStripe.toggle()
        }
        .accessibilityLabel("Show templates")
        .help("Show templates")
        .keyboardShortcut(.init("t"))
        .buttonStyle(BorderlessButtonStyle())
    }

    @ViewBuilder
    func lastMessageAsPrompt() -> some View {
        Button("", systemImage: "memories") {
            focusedField = true
            prompt = chatViewService.getLastChatMessageContent(workspace: workspace)
        }
        .accessibilityLabel("Set last message as prompt")
        .help("Set last message as prompt")
        .keyboardShortcut(.upArrow)
        .buttonStyle(BorderlessButtonStyle())
    }

    @ViewBuilder
    func sendButton() -> some View {
        Button("", systemImage: "paperplane.fill") {
            chatViewService.executePrompt(workspace: workspace, prompt: prompt)
            prompt = ""
        }
        .accessibilityLabel("Send")
        .help("Send")
        .keyboardShortcut(.return)
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ChatView()
            .environment(previewer.chatViewService)
            .frame(width: 700, height: 600)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
