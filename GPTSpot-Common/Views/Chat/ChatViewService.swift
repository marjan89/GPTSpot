//
//  ChatViewService.swift
//  GPTSpot
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import SwiftData
import SwiftUI

@Observable
public final class ChatViewService {

    let throttleIntervalInSeconds = 0.1

    public var generatingContent: Bool = false

    private let modelContext: ModelContext
    private let openAiService: OpenAIService

    public init(modelContext: ModelContext, openAISerice: OpenAIService) {
        self.modelContext = modelContext
        self.openAiService = openAISerice
    }

    public func executePrompt(workspace: Int, prompt: String) {
        if generatingContent {
            return
        }
        Task { @MainActor in
            let sanitizedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)

            if sanitizedPrompt.isEmpty {
                return
            }
            generatingContent = true

            insertOrUpdateChatMessage(for: modifiedPrompt(prompt), origin: .user, workspace: workspace)
            let chatRequest = ChatRequest.request(with: self.loadChatHistory(for: workspace))
            var responseBuffer: [(String, String)] = []
            var time = Date().timeIntervalSince1970
            if let messageStream = try? await openAiService.completion(for: chatRequest) {
                for await message in messageStream {
                    switch message {
                    case .response(let chunk, let id):
                        responseBuffer.append((id, chunk))
                        if Date().timeIntervalSince1970 - time > throttleIntervalInSeconds {
                            insertBufferedResponses(for: responseBuffer, workspace: workspace)
                            time = Date().timeIntervalSince1970
                            responseBuffer.removeAll()
                        }
                    case .terminator:
                        if !responseBuffer.isEmpty {
                            insertBufferedResponses(for: responseBuffer, workspace: workspace)
                            time = Date().timeIntervalSince1970
                            responseBuffer.removeAll()
                        }
                        self.generatingContent = false
                    case .error(let errorType):
                        self.insertChatMessage(
                            for: handleError(error: errorType),
                            origin: .system,
                            workspace: workspace
                        )
                        self.generatingContent = false
                    }
                }
            }
        }
    }

    private func insertBufferedResponses(for responseBuffer: [(String, String)], workspace: Int) {
        if responseBuffer.isEmpty {
            return
        }
        guard let id = responseBuffer.first?.0 else {
            return
        }

        let chunk = responseBuffer.map { response in response.1 }.joined()
        self.insertOrUpdateChatMessage(for: chunk, origin: .assistant, id: id, workspace: workspace)
    }

    public func savePrompAsTemplate(_ prompt: String) {
        modelContext.insert(Template(content: prompt))
    }

    public func cancelCompletion() {
        openAiService.cancelCompletion()
        generatingContent = false
    }

    public func deleteChatMessage(_ chatMessage: ChatMessage) {
        modelContext.delete(chatMessage)
    }

    public func insertTemplate(_ template: Template) {
        modelContext.insert(template)
    }

    public func discardHistory(for workspace: Int) {
        try? modelContext.delete(
            model: ChatMessage.self,
            where: #Predicate<ChatMessage> { message in
                message.workspace == workspace
            }
        )
    }

    public func deleteTemplate(_ template: Template) {
        modelContext.delete(template)
    }

    public func getLastChatMessageContent(workspace: Int) -> String {
        var lastChatMessagesFetchDescriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate<ChatMessage> { message in
                message.origin == "user" && message.workspace == workspace
            },
            sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
        )
        lastChatMessagesFetchDescriptor.fetchLimit = 1
        if let lastMessageContent = try? modelContext.fetch(lastChatMessagesFetchDescriptor).first?.content {
            return lastMessageContent
        }

        return ""
    }

    private func handleError(error: MessageErrorType) -> String {
        let error = switch error {
        case .invalidToken:
            String(localized: "Response error: Token is invalid")
        case .invalidRegion:
            String(localized: "Response error: Not supported in your region")
        case .modelUnavailable:
            String(localized: "Reponse error: Model is not available")
        case .rateLimitReached:
            String(localized: "Response error: You reached your rate limit")
        case .serverError:
            String(localized: "Server error")
        case .serverOverload:
            String(localized: "Response error: Server appears to be ovreloaded at the moment")
        case .userCanceled:
            String(localized: "Response canceled by user")
        case .unknown(let message):
            message
        default:
            String(localized: "Response error: Unknown")
        }
        return error
    }

    private func modifiedPrompt(_ prompt: String) -> String {
        if UserDefaults.standard.bool(forKey: AIServerDefaultsKeys.usePrompPrefix) {
            let promptPrefix = UserDefaults.standard.string(forKey: AIServerDefaultsKeys.promptPrefix)
            if let promptPrefix = promptPrefix {
                return """
\(promptPrefix)\r\n
\(prompt)
"""
            } else {
                return prompt
            }
        } else {
            return prompt
        }
    }

    private func loadChatHistory(for workspace: Int) -> [ChatRequest.Message] {
        var chatMessageHistoryFetchDescriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate<ChatMessage> { message in
                message.workspace == workspace && message.origin != "system"
            },
            sortBy: [.init(\ChatMessage.timestamp, order: .reverse)]
        )
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

    private func insertChatMessage(for content: String, origin: Role, id: String = UUID().uuidString, workspace: Int) {
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
