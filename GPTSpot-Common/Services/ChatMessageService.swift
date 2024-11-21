//
//  ChatMessageService.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 11/6/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
public class ChatMessageService {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func insertOrUpdateChatMessage(for content: String, origin: Role, id: String = "", workspace: Int) {
        if origin == .user {
            insertChatMessage(for: content, origin: origin, id: UUID().uuidString, workspace: workspace)
            return
        }
        let searchPredicate = #Predicate<ChatMessage> { message in
            message.id == id
        }
        let persistedMessage = try? modelContext.fetch(FetchDescriptor<ChatMessage>(predicate: searchPredicate)).first
        if let persistedMessage {
            persistedMessage.content += content
        } else {
            insertChatMessage(for: content, origin: origin, id: id, workspace: workspace)
        }
        try? modelContext.save()
    }

    public func insertChatMessage(for content: String, origin: Role, id: String = UUID().uuidString, workspace: Int) {
        let chatMessage = ChatMessage(
            content: content,
            origin: origin.rawValue,
            timestamp: Date().timeIntervalSince1970,
            id: id,
            workspace: workspace
        )
        modelContext.insert(chatMessage)
        try? modelContext.save()
    }

    public func deleteChatMessage(_ chatMessage: ChatMessage) {
        let id = chatMessage.id
        try? modelContext.delete(
            model: ChatMessage.self,
            where: #Predicate<ChatMessage> { message in message.id == id }
        )
        try? modelContext.save()
    }

    public func discardHistory(for workspace: Int) {
        try? modelContext.delete(
            model: ChatMessage.self,
            where: #Predicate<ChatMessage> { message in
                message.workspace == workspace
            }
        )
        try? modelContext.save()
    }

    public func getLastChatMessageContent(for workspace: Int) -> String {
        let lastChatMessagesFetchDescriptor = {
            var descriptor = FetchDescriptor<ChatMessage>(
                predicate: #Predicate<ChatMessage> { message in
                    message.origin == "user" && message.workspace == workspace
                },
                sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
            )
            descriptor.fetchLimit = 1
            return descriptor
        }()
        if let lastMessageContent = try? modelContext.fetch(lastChatMessagesFetchDescriptor).first?.content {
            return lastMessageContent
        }
        return ""
    }
}
