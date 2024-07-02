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

    init(
        onSwipeDelete: @escaping (_: Int) -> Void,
        onEmptyViewAction: @escaping () -> Void
    ) {
        self.onSwipeDelete = onSwipeDelete
        self.onEmptyViewAction = onEmptyViewAction
    }

    private var activeWorkspaces: [Int] {
        chatMessages
            .map { chatMessage in chatMessage.workspace }
            .distinct
            .sorted()
    }

    var body: some View {
        if activeWorkspaces.isEmpty {
            VStack {
                Image(uiImage: UIImage(named: "AppIcon")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .contentMargins(.bottom, 16)
                Button("Start a conversation") {
                    onEmptyViewAction()
                }
            }
        } else {
            List(activeWorkspaces, id: \.self) { workspace in
                NavigationLink(value: WorkspaceHomePath.workspace(workspace)) {
                    WorkspaceListItemView(
                        workspaceIndex: workspace,
                        content: chatMessages.last(where: { chatMessage in
                            chatMessage.workspace == workspace
                        })?.content ?? ""
                    )
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        onSwipeDelete(workspace)
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    @State var path = [WorkspaceHomePath]()
    return Previewer {
        WorkspaceListView(
            onSwipeDelete: { _ in },
            onEmptyViewAction: { }
        )
    }
}
