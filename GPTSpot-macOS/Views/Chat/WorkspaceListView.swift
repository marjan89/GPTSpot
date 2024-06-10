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
    private let onSwipeDelete: (_ workspace: Int) -> Void
    private let onEmptyViewAction: () -> Void
    @Binding var activeWorkspace: Int

    init(
        onSwipeDelete: @escaping (_: Int) -> Void,
        onEmptyViewAction: @escaping () -> Void,
        activeWorkspace: Binding<Int>
    ) {
        self.onSwipeDelete = onSwipeDelete
        self.onEmptyViewAction = onEmptyViewAction
        self._activeWorkspace = activeWorkspace
    }

    private var activeWorkspaces: [Int] {
        let workspaces = chatMessages
            .map { chatMessage in chatMessage.workspace }
            .distinct<T>()
            .sorted()
        return if !workspaces.contains(activeWorkspace) {
            [activeWorkspace] + workspaces
        } else {
            workspaces
        }
    }

    private var inactiveWorkspaces: [Int] {
        Array(WorkspaceConfig.firstOrdinal..<WorkspaceConfig.workspaceLimit)
            .filter { workspace in
                !activeWorkspaces.contains(workspace)
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
                            onSwipeDelete(activeWorkspace)
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

        return WorkspaceListView(
            onSwipeDelete: { _ in
            },
            onEmptyViewAction: {

            },
            activeWorkspace: $workspace
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
