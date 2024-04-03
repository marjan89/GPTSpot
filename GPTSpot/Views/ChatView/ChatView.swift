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
    
    @FocusState private var focusedField: FocusedField?
    
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
                if showTemplateStripe {
                    TemplateStripeView(
                        searchQuery: templateSearchQuery,
                        onTemplateSelected: { template in
                            chatViewService.prompt = template.content
                            showTemplateStripe = false
                            templateSearchQuery = ""
                        }
                    )
                    .frame(height: 196)
                }
                ZStack {
                    if showTemplateStripe && templateSearchQuery.isEmpty {
                        Text("Search templates")
                            .padding(.top, 6)
                            .padding(.leading, 16)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 8, alignment: .topLeading)
                    }
                    if !showTemplateStripe && chatViewService.prompt.isEmpty {
                        Text("Send a message")
                            .padding(.top, 6)
                            .padding(.leading, 16)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 8, alignment: .topLeading)
                    }
                    TextEditor(text: showTemplateStripe ? $templateSearchQuery : $chatViewService.prompt)
                        .padding(.all, 8)
                        .accessibilityHidden(true)
                        .scrollClipDisabled()
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .focused($focusedField, equals: .prompt)
                        .onAppear {
                            focusedField = .prompt
                        }
                        .roundedCorners(strokeColor: .gray)
                        .frame(height: geometry.size.height / 8)
                }
                HStack {
                    WorkspaceIndicatorView(workspace: $workspace)
                    Spacer()
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
                if showHelpRibbon {
                    CheatSheetView()
                }
                if showStats {
                    StatsView(workspace: workspace)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 8)
        }
        .background(.windowBackground)
        .roundedCorners(radius: 16, strokeColor: Color.black)
        .padding(.all, 20)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.66), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
