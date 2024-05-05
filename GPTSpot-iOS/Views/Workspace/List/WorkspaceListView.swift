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

    enum Path {
        case settings
    }

    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.openAIService) private var openAiService: OpenAIService
    @Environment(ChatViewService.self) private var chatViewService: ChatViewService

    @Query private var chatMessages: [ChatMessage]

    private var workspaces: [Int] {
        chatMessages
            .map { chatMessage in chatMessage.workspace }
            .distinct<T>()
    }

    @State private var path = [Path]()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(workspaces, id: \.self) { index in
                    NavigationLink {
                        WorkspaceChatView(
                            chatViewService: chatViewService,
                            workspace: index
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("", systemImage: "trash.fill") {
                                    chatViewService.discardHistory(for: index)
                                }
                            }
                        }
                        .toolbarBackground(.hidden, for: .navigationBar)
                        .safeAreaInset(edge: .top) {
                            Color(.clear)
                                .frame(height: 0)
                                .background(.bar)
                        }
                    } label: {
                        WorkspaceItemView(workspaceIndex: index)
                    }
                }
            }
            .navigationTitle("Workspace")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("", systemImage: "gearshape.fill") {
                        path.append(.settings)
                    }
                }
            }
            .navigationDestination(for: Path.self) { _ in
                SettingsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Settings")
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
