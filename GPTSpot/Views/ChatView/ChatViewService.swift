//
//  ChatViewService.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import SwiftData
import SwiftUI

@Observable final class ChatViewService {
    
    var prompt: String = ""
    
    private var generatingContent: Bool = false
    private let modelContext: ModelContext
    private let openAiService: OpenAIService
    
    private var chatMessageHistoryFetchDescriptor = FetchDescriptor<ChatMessage>(
        sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
    )
    
    init(modelContext: ModelContext, openAISerice: OpenAIService) {
        self.modelContext = modelContext
        self.openAiService = openAISerice
    }
    
    func executePrompt(shouldDiscardHistory: Bool = false, workspace: Int) {
        if generatingContent {
            return
        }
        generatingContent = true
        Task { @MainActor in
            if shouldDiscardHistory {
                discardHistory(for: workspace)
            }
            let sanitizedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if sanitizedPrompt.isEmpty {
                return
            }
            insertOrUpdateChatMessage(for: sanitizedPrompt, origin: .user, workspace: workspace)
            let chatRequest = ChatRequest.request(with: self.loadChatHistory(for: workspace))
            prompt = ""
            if let messageStream = try? await openAiService.completion(for: chatRequest) {
                for await message in messageStream {
                    switch message {
                    case .response(let chunk, let id):
                        self.insertOrUpdateChatMessage(for: chunk, origin: .assistant, id: id, workspace: workspace)
                    case .terminator:
                        self.generatingContent = false
                    case .error:
                        print("error")
                    }
                }
            }
        }
    }
    
    func discardHistory(for workspace: Int) {
        try? modelContext.delete(
            model: ChatMessage.self,
            where: #Predicate<ChatMessage> { message in
                message.workspace == workspace
            }
        )
    }
    
    func setLastChatMessageAsPrompt(workspace: Int) {
        var lastChatMessagesFetchDescriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate<ChatMessage> { message in
                message.origin == "user" && message.workspace == workspace
            },
            sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
        )
        lastChatMessagesFetchDescriptor.fetchLimit = 1
        if let lastMessage = try? modelContext.fetch(lastChatMessagesFetchDescriptor).first {
            prompt = lastMessage.content
        }
    }
    
    private func loadChatHistory(for workspace: Int) -> [ChatRequest.Message] {
        let userLimit = UserDefaults.standard.integer(forKey: AIServerDefaultsKeys.maxHistory)
        if userLimit > 0 {
            chatMessageHistoryFetchDescriptor.fetchLimit = userLimit
        }
        let chatMessages = try? modelContext.fetch(chatMessageHistoryFetchDescriptor)
        let history = chatMessages?.map { message in
            ChatRequest.Message(
                role: message.origin,
                content: message.content
            )
        }.reversed() ?? []
        return history
    }
    
    private func insertOrUpdateChatMessage(for content: String, origin: Role, id: String = "", workspace: Int) {
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
    }
    
    private func insertChatMessage(for content: String, origin: Role, id: String = "", workspace: Int) {
        let chatMessage = ChatMessage(
            content: content,
            origin: origin.rawValue,
            timestamp: Date().timeIntervalSince1970,
            id: id,
            workspace: workspace
        )
        modelContext.insert(chatMessage)
    }
}
