//
//  WorkspaceList.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 7/6/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct WorkspaceListView: View {

    @Query(sort: \ChatMessage.timestamp) private var chatMessages: [ChatMessage]
    private let onItemDelete: (_ workspace: Int) -> Void
    @Binding var activeWorkspace: Int
    @Binding var query: String

    init(
        onItemDelete: @escaping (_: Int) -> Void,
        activeWorkspace: Binding<Int>,
        query: Binding<String>
    ) {
        self.onItemDelete = onItemDelete
        self._activeWorkspace = activeWorkspace
        self._query = query
    }

    private var activeWorkspaces: [Int] {
        let workspaces = chatMessages
            .filter { message in
                if query.isEmpty {
                    return true
                } else {
                    let words = query
                        .lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .whitespaces)
                    let queryMatched = words.contains { word in
                        message.content.lowercased().contains(word)
                    }
                    return queryMatched
                }
            }
            .map { chatMessage in chatMessage.workspace }
            .distinct
            .sorted()
        return if query.isEmpty && !workspaces.contains(activeWorkspace) {
            [activeWorkspace] + workspaces
        } else {
            workspaces
        }
    }

    var body: some View {
        ZStack {
            hotkeys()
            if activeWorkspaces.isEmpty {
                List {
                    WorkspaceListItemView(
                        workspaceIndex: activeWorkspace,
                        selected: true,
                        content: "Start a conversation",
                        onWorkspaceSelected: { workspace in
                            activeWorkspace = workspace
                        }
                    )
                    .id(activeWorkspace)
                }
                .scrollContentBackground(.hidden)
            } else {
                List(activeWorkspaces, id: \.self) { workspace in
                    WorkspaceListItemView(
                        workspaceIndex: workspace,
                        selected: workspace == activeWorkspace,
                        content: chatMessages.last(where: { chatMessage in
                            chatMessage.workspace == workspace
                        })?.content ?? "",
                        onWorkspaceSelected: { workspace in
                            activeWorkspace = workspace
                        }
                    )
                    .id(activeWorkspace)
                    .contextMenu(ContextMenu {
                        Button {
                            onItemDelete(activeWorkspace)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    })
                }
                .scrollContentBackground(.hidden)
            }
        }
    }

    private func hotkeys() -> some View {
        ForEach(WorkspaceConfig.firstOrdinal..<WorkspaceConfig.workspaceLimit, id: \.self) { ordinal in
            HotkeyAction(hotkey: .init(Character(UnicodeScalarType(ordinal)))) {
                activeWorkspace = ordinal
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        @State var workspace: Int = 1
        @State var query: String = ""

        return WorkspaceListView(
            onItemDelete: { _ in
            },
            activeWorkspace: $workspace,
            query: $query
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
