//
//  WorkspaceHomeService.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 7/6/24.
//

import Foundation
import SwiftData
import GPTSpot_Common

@Observable
final class WorkspaceHomeService {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func getInactiveWorkspaces() -> [Int] {
        guard let chatMessages = try? modelContext.fetch(FetchDescriptor<ChatMessage>()) else {
            return []
        }

        let activeWorkspaces = chatMessages
            .map { chatMessage in chatMessage.workspace }
            .distinct
            .sorted()
        return Array(WorkspaceConfig.firstOrdinal..<WorkspaceConfig.workspaceLimit)
            .filter { workspace in
                !activeWorkspaces.contains(workspace)
            }
    }
}
