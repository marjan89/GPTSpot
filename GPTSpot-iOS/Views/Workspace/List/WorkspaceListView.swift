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

    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.openAIService) var openAiService: OpenAIService
    @Environment(ChatViewService.self) var chatViewService: ChatViewService
    @State private var path = [Path]()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(0..<10) { index in
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
            }
        }
    }
}

#Preview {
    WorkspaceListView()
}
