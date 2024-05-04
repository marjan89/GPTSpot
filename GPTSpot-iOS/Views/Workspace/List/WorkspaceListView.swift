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

    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.openAIService) var openAiService: OpenAIService

    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { index in
                    NavigationLink {
                        WorkspaceChatView(
                            chatViewService: .init(modelContext: modelContext, openAISerice: openAiService),
                            workspace: index
                        )
                    } label: {
                        WorkspaceItemView(workspaceIndex: index)
                    }
                }
            }
            .navigationTitle("Workspace")
            .toolbarRole(.navigationStack)
            .toolbar {
                Button("", systemImage: "gearshape.fill") {
                    
                }
            }
        }
    }
}

#Preview {
    WorkspaceListView()
}
