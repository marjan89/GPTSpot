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

    @FocusState private var focusedField: Bool

    @State var workspace = 1
    @State var showHelpRibbon = false
    @State var showStats = false
    @State var showTemplateStripe = false
    @State var templateSearchQuery = ""
    @State var prompt = ""
    private let windowed = UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.windowed)

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if windowed {
                    WorkspaceListView(
                        onSwipeDelete: { workspace in
                            chatViewService.discardHistory(for: workspace)
                        },
                        onEmptyViewAction: {},
                        activeWorkspace: $workspace
                    )
                    .background(.windowBackground)
                    .frame(width: 312)
                    .toolbar {
                        chatControlsToolbar(placement: .primaryAction)
                    }
                }
                VStack(spacing: 0) {
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
                        if showHelpRibbon {
                            CheatSheetView()
                        }
                        if !windowed && showStats {
                            StatsView(workspace: workspace)
                        }
                        if !windowed {
                            chatControls()
                        }
                    }
                    .padding(.all, 16)
                    .background(.regularMaterial)
                }
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
            Group {
                WorkspaceIndicatorView(workspace: $workspace)
                Spacer()
                saveAsTemplateButton()
                stopGeneratingContentButton()
                helpButton()
                statsButton()
                trashButton()
                templatesButton()
                lastMessageAsPrompt()
                sendButton()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    func chatControlsToolbar(placement: ToolbarItemPlacement) -> ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: placement) {
            Group {
                StatsView(workspace: workspace)
                saveAsTemplateButton()
                stopGeneratingContentButton()
                helpButton()
                statsButton()
                trashButton()
                templatesButton()
                lastMessageAsPrompt()
                sendButton()
            }
            .buttonStyle(AccessoryBarButtonStyle())
        }
    }

    @ViewBuilder
    private func saveAsTemplateButton() -> some View {
        if !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !templateSearchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Button {
                if showTemplateStripe {
                    chatViewService.insertTemplate(Template(content: templateSearchQuery))
                    templateSearchQuery = ""
                } else {
                    chatViewService.savePrompAsTemplate(prompt)
                }
            } label: {
                Image(systemName: "square.and.arrow.down.fill")
            }
            .accessibilityLabel("Save as template")
            .help("Save as template")
            .keyboardShortcut(.init("s", modifiers: [.command]))
        }
    }

    @ViewBuilder
    private func stopGeneratingContentButton() -> some View {
        if chatViewService.generatingContent {
            Button {
                chatViewService.cancelCompletion()
            } label: {
                Image(systemName: "stop.fill")
            }
            .accessibilityLabel("Cancel response")
            .help("Cancel response")
            .keyboardShortcut(.init(.return, modifiers: [.command, .shift]))
        }
    }

    @ViewBuilder
    private func helpButton() -> some View {
        Button {
            showHelpRibbon.toggle()
        } label: {
            Image(systemName: "questionmark.circle.fill")
        }
        .accessibilityLabel("Show help")
        .help("Show help")
        .keyboardShortcut(.init("?"))
    }

    @ViewBuilder
    private func statsButton() -> some View {
        Button {
            showStats.toggle()
        } label: {
            Image(systemName: "chart.bar.fill")
        }
        .accessibilityLabel("Show stats")
        .help("Show stats")
        .keyboardShortcut(.init("."))
    }

    @ViewBuilder
    private func trashButton() -> some View {
        Button {
            chatViewService.discardHistory(for: workspace)
        } label: {
            Image(systemName: "trash.fill")
        }
        .accessibilityLabel("Discard history")
        .help("Discard history")
        .keyboardShortcut(.init("d"))
    }

    @ViewBuilder
    private func templatesButton() -> some View {
        Button {
            showTemplateStripe.toggle()
        } label: {
            Image(systemName: "folder.fill")
        }
        .accessibilityLabel("Show templates")
        .help("Show templates")
        .keyboardShortcut(.init("t"))
    }

    @ViewBuilder
    private func lastMessageAsPrompt() -> some View {
        Button {
            focusedField = true
            prompt = chatViewService.getLastChatMessageContent(workspace: workspace)
        } label: {
            Image(systemName: "memories")
        }
        .accessibilityLabel("Set last message as prompt")
        .help("Set last message as prompt")
        .keyboardShortcut(.upArrow)
    }

    @ViewBuilder
    private func sendButton() -> some View {
        Button {
            chatViewService.executePrompt(workspace: workspace, prompt: prompt)
            prompt = ""
        } label: {
            Image(systemName: "paperplane.fill")
        }
        .accessibilityLabel("Send")
        .help("Send")
        .keyboardShortcut(.return)
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
