//
//  WorkspaceListView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct WorkspaceListView: View {

    private enum Path: Hashable {
        case settings
        case workspace(Int)
    }

    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.openAIService) private var openAiService: OpenAIService
    @Environment(ChatViewService.self) private var chatViewService: ChatViewService

    @Query private var chatMessages: [ChatMessage]

    private var activeWorkspaces: [Int] {
        chatMessages
            .map { chatMessage in chatMessage.workspace }
            .distinct<T>()
            .sorted()
    }

    private var inactiveWorkspaces: [Int] {
        Array(1..<10)
            .filter { workspace in
                !activeWorkspaces.contains(workspace)
            }
    }

    @State private var path = [Path]()
    @State private var newWorkspaceDialog = false

    var body: some View {
        NavigationStack(path: $path) {
            mainContent()
                .navigationTitle("Workspace")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("", systemImage: "gearshape.fill") {
                            path.append(.settings)
                        }
                        .accessibilityLabel("")
                        Button("", systemImage: "plus") {
                            newWorkspaceDialog.toggle()
                        }
                        .accessibilityLabel("New workspace")
                        .confirmationDialog(
                            "New workspace",
                            isPresented: $newWorkspaceDialog,
                            titleVisibility: .visible,
                            actions: {
                                ForEach(inactiveWorkspaces, id: \.self) { workspace in
                                    Button("⌘\(workspace)") {
                                        path.append(.workspace(workspace))
                                    }
                                }
                            },
                            message: {
                                Text("Available workspaces")
                            }
                        )
                    }
                }
                .navigationDestination(for: Path.self) { path in
                    switch path {
                    case .settings:
                        SettingsView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Settings")
                    case .workspace(let workspace):
                        WorkspaceChatView(workspace: workspace)
                    }
                }
        }
    }

    @ViewBuilder
    private func mainContent() -> some View {
        if activeWorkspaces.isEmpty {
            VStack {
                Image(uiImage: UIImage(named: "AppIcon")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .contentMargins(.bottom, 16)
                Button("Start a conversation") {
                    path.append(.workspace(1))
                }
            }
        } else {
            List {
                ForEach(activeWorkspaces, id: \.self) { workspace in
                    NavigationLink(value: Path.workspace(workspace)) {
                        WorkspaceItemView(workspaceIndex: workspace)
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            chatViewService.discardHistory(for: workspace)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return WorkspaceListView()
            .modelContainer(previewer.container)
            .environment(ChatViewService(
                modelContext: previewer.container.mainContext,
                openAISerice: OpenAIServiceKey.defaultValue
            ))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
