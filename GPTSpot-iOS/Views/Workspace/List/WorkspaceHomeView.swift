//
//  WorkspaceListView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct WorkspaceHomeView: View {

    @Environment(ChatViewService.self) private var chatViewService: ChatViewService
    @Environment(WorkspaceHomeService.self) private var workspaceHomeService: WorkspaceHomeService

    @State private var path = [WorkspaceHomePath]()
    @State private var newWorkspaceDialog = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if path.isEmpty {
                    WorkspaceListView(
                        onSwipeDelete: { workspace in
                            chatViewService.discardHistory(for: workspace)
                        },
                        onEmptyViewAction: {
                            path.append(.workspace(1))
                        }
                    )
                } else {
                    EmptyView()
                }
            }
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
                            ForEach(workspaceHomeService.getInactiveWorkspaces(), id: \.self) { workspace in
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
            .navigationDestination(for: WorkspaceHomePath.self) { path in
                switch path {
                case .settings:
                    SettingsView()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Settings")
                case .workspace(let workspace):
                    ChatView(workspace: workspace)
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return WorkspaceHomeView()
            .modelContainer(previewer.container)
            .environment(previewer.chatViewService)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
