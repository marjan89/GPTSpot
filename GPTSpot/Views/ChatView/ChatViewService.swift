//
//  ChatViewService.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import SwiftData

@Observable final class ChatViewService {
    
    var prompt: String = ""
    var generatingContent: Bool = false
    var modelContext: ModelContext
    var streamCounter: Int32 = 0
    
    private var chatMessagesFetchDescriptor = FetchDescriptor<ChatMessage>(
        sortBy: [.init(\ChatMessage.timestamp)]
    )
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    private let openAiService = OpenAIService()
    
    func executePrompt(shouldDiscardHistory: Bool = false) {
        if generatingContent {
            return
        }
        generatingContent = true
        Task { @MainActor in
            if shouldDiscardHistory {
                discardHistory()
            }
            insertOrUpdateChatMessage(for: prompt.trimmingCharacters(in: .whitespacesAndNewlines), origin: .user)
            let chatRequest = ChatRequest.request(with: self.loadChatHistory())
            prompt = ""
            try? await openAiService.completion(
                for: chatRequest,
                with: { message in
                    switch message {
                    case .response(let chunk, let id):
                        self.insertOrUpdateChatMessage(for: chunk, origin: .assistant, id: id)
                    case .terminator:
                        self.generatingContent = false
                    case .error:
                        print("error")
                    }
                    self.streamCounter += 1
                }
            )
        }
    }
    
    func discardHistory() {
        try? modelContext.delete(model: ChatMessage.self)
    }
    
    private func loadChatHistory() -> [ChatRequest.Message] {
        let chatMessages = try? modelContext.fetch(chatMessagesFetchDescriptor)
        let history = chatMessages?.map { message in
            ChatRequest.Message(
                role: message.origin,
                content: message.content
            )
        } ?? []
        return history
    }
    
    private func insertOrUpdateChatMessage(for content: String, origin: Role, id: String = "") {
        if origin == .user {
            insertChatMessage(for: content, origin: origin, id: UUID().uuidString)
            return
        }
        let searchPredicate = #Predicate<ChatMessage> { message in
            message.id == id
        }
        let persistedMessage = try? modelContext.fetch(FetchDescriptor<ChatMessage>(predicate: searchPredicate)).first
        if let persistedMessage {
            persistedMessage.content += content
        } else {
            insertChatMessage(for: content, origin: origin, id: id)
        }
    }
    
    private func insertChatMessage(for content: String, origin: Role, id: String = "") {
        let chatMessage = ChatMessage(
            content: content,
            origin: origin.rawValue,
            timestamp: Date().timeIntervalSince1970,
            id: id
        )
        modelContext.insert(chatMessage)
    }
}
