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

    @Bindable private var chatViewService: ChatViewService

    @Environment(\.modelContext) private var modelContext

    @FocusState private var focusedField: Bool
    @AppStorage(AIServerDefaultsKeys.usePrompPrefix) private var promptPrefix: Bool = false

    @State var workspace = 1
    @State var showHelpRibbon = false
    @State var showStats = false
    @State var showTemplateStripe = false
    @State var templateSearchQuery = ""

    init(chatViewService: ChatViewService) {
        self.chatViewService = chatViewService
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                ChatListView(
                    workspace: workspace,
                    prompt: $chatViewService.prompt
                )
                VStack {
                    VStack {
                        if showTemplateStripe {
                            TemplateStripeView(
                                searchQuery: templateSearchQuery,
                                onTemplateSelected: { template in
                                    chatViewService.appendToPrompt(template.content)
                                    focusedField = true
                                    showTemplateStripe = false
                                    templateSearchQuery = ""
                                }
                            )
                            .frame(height: 196)
                        }
                        PromptEditor(
                            showTemplateHint: $showTemplateStripe,
                            templateSearchQuery: $templateSearchQuery,
                            prompt: $chatViewService.prompt,
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
                }
                .background(.regularMaterial)
            }
        }
        .background(.windowBackground)
        .window()
    }

    @ViewBuilder
    func chatControls() -> some View {
        HStack {
            Spacer()
            Toggle(
                isOn: $promptPrefix,
                label: {
                    Text("Prompt prefix")
                }
            )
            .toggleStyle(SwitchToggleStyle())
            .keyboardShortcut(.init("/"))
            if chatViewService.generatingContent {
                Button("", systemImage: "stop.fill") {
                    chatViewService.cancelCompletion()
                }
                .accessibilityLabel("Cancel response")
                .keyboardShortcut(.init(.return, modifiers: [.command, .shift]))
                .buttonStyle(BorderlessButtonStyle())
            }
            Button("", systemImage: "questionmark.circle.fill") {
                showHelpRibbon.toggle()
            }
            .accessibilityLabel("Show help")
            .keyboardShortcut(.init("?"))
            .buttonStyle(BorderlessButtonStyle())
            Button("", systemImage: "chart.bar.fill") {
                showStats.toggle()
            }
            .accessibilityLabel("Show stats")
            .keyboardShortcut(.init("."))
            .buttonStyle(BorderlessButtonStyle())
            Button("", systemImage: "trash.fill") {
                chatViewService.discardHistory(for: workspace)
            }
            .accessibilityLabel("Discard history")
            .keyboardShortcut(.init("d"))
            .buttonStyle(BorderlessButtonStyle())
            Button("", systemImage: "folder.fill") {
                showTemplateStripe.toggle()
            }
            .accessibilityLabel("Show templates")
            .keyboardShortcut(.init("t"))
            .buttonStyle(BorderlessButtonStyle())
            Button("", systemImage: "memories") {
                focusedField = true
                chatViewService.setLastChatMessageAsPrompt(workspace: workspace)
            }
            .accessibilityLabel("Set last message as prompt")
            .keyboardShortcut(.upArrow)
            .buttonStyle(BorderlessButtonStyle())
            Button("", systemImage: "paperplane.fill") {
                chatViewService.executePrompt(workspace: workspace)
            }
            .accessibilityLabel("Send")
            .keyboardShortcut(.return)
            .buttonStyle(BorderlessButtonStyle())
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
        .frame(width: 700, height: 600)
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
