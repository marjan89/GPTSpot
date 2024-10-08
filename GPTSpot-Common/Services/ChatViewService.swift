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
    public var generatingContent: Bool = false

    private let modelContext: ModelContext
    private let openAiService: OpenAIService
    private let chatMessageService: ChatMessageService

    public init(modelContext: ModelContext, openAISerice: OpenAIService, chatMessageService: ChatMessageService) {
        self.modelContext = modelContext
        self.openAiService = openAISerice
        self.chatMessageService = chatMessageService
    }

    public func discardHistory(for workspace: Int) {
        cancelCompletion()
        chatMessageService.discardHistory(for: workspace)
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

            await initializeWithSystemMessageIfEnabled(for: workspace)

            chatMessageService.insertOrUpdateChatMessage(for: prompt, origin: .user, workspace: workspace)

            let chatRequest = ChatRequest.request(with: loadChatHistory(for: workspace))
            var responseBuffer: [(String, String)] = []
            var time = Date().timeIntervalSince1970
            if let messageStream = try? await openAiService.completion(for: chatRequest) {
                for await message in messageStream {
                    switch message {
                    case .response(let chunk, let id):
                        responseBuffer.append((id, chunk))
                        if Date().timeIntervalSince1970 - time > Constants.throttleIntervalInSeconds {
                            insertBufferedResponses(for: responseBuffer, workspace: workspace)
                            time = Date().timeIntervalSince1970
                            responseBuffer.removeAll()
                        }
                    case .terminator:
                        insertBufferedResponses(for: responseBuffer, workspace: workspace)
                        generatingContent = false
                    case .error(let errorType):
                        chatMessageService.insertChatMessage(
                            for: handleError(error: errorType),
                            origin: .local,
                            workspace: workspace
                        )
                        generatingContent = false
                    }
                }
            }
        }
    }

    private func initializeWithSystemMessageIfEnabled(for workspace: Int) async {
        if let systemMessage = UserDefaults.standard.string(forKey: UserDefaults.AIServerKeys.systemMessage),
           !systemMessage.isEmpty,
           UserDefaults.standard.bool(forKey: UserDefaults.AIServerKeys.useSystemMessage) {
            let messageCount = {
                let messageCountFetchDescriptor = FetchDescriptor<ChatMessage>(
                    predicate: #Predicate<ChatMessage> { message in
                        message.workspace == workspace && message.origin != "local"
                    },
                    sortBy: [.init(\ChatMessage.timestamp)]
                )
                return try? modelContext.fetchCount(messageCountFetchDescriptor)
            }()

            if messageCount == 0 {
                let systemRequest = ChatRequest.systemRequest()
                chatMessageService.insertChatMessage(
                    for: systemMessage,
                    origin: .system,
                    id: UUID().uuidString,
                    workspace: workspace
                )
                do {
                    try await openAiService.request(for: systemRequest)
                    chatMessageService.insertOrUpdateChatMessage(
                        for: "🛠️ This workspace is using a system message: \(systemMessage)",
                        origin: .local,
                        id: UUID().uuidString,
                        workspace: workspace
                    )
                } catch {
                    chatMessageService.insertOrUpdateChatMessage(
                        for: "⚠️ Failed to set system message.",
                        origin: .local,
                        id: UUID().uuidString,
                        workspace: workspace
                    )
                }
            }
        }
    }

    private func insertBufferedResponses(for responseBuffer: [(String, String)], workspace: Int) {
        guard let id = responseBuffer.first?.0, !responseBuffer.isEmpty else { return }

        let chunk = responseBuffer.map { response in response.1 }.joined()
        chatMessageService.insertOrUpdateChatMessage(for: chunk, origin: .assistant, id: id, workspace: workspace)
    }

    public func cancelCompletion() {
        openAiService.cancelCompletion()
        generatingContent = false
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

    private func loadChatHistory(for workspace: Int) -> [ChatRequest.Message] {
        let chatMessageHistoryFetchDescriptor = {
            var descriptor = FetchDescriptor<ChatMessage>(
                predicate: #Predicate<ChatMessage> { message in
                    message.workspace == workspace && message.origin != "local"
                },
                sortBy: [.init(\ChatMessage.timestamp)]
            )
            let userLimit = UserDefaults.standard.integer(forKey: UserDefaults.AIServerKeys.maxHistory)
            if userLimit > 0 {
                descriptor.fetchLimit = userLimit
            }
            return descriptor
        }()
        let systemMessageFetchDescriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate<ChatMessage> { message in
                message.origin == "system"
            }
        )
        do {
            let chatMessages = try modelContext.fetch(chatMessageHistoryFetchDescriptor)
            let systemMessages = try modelContext.fetch(systemMessageFetchDescriptor)
            let history = chatMessages.map { message in
                ChatRequest.Message(
                    role: message.origin,
                    content: message.content
                )
            }
            return if let systemMessage = systemMessages.first, !chatMessages.contains(
                where: { message in
                    message.origin == "system"
                }
            ) {
                [ChatRequest.Message(
                    role: systemMessage.origin,
                    content: systemMessage.content
                )] + history
            } else {
                history
            }
        } catch {
            chatMessageService.insertOrUpdateChatMessage(
                for: "Response error: failed to fetch history",
                origin: .local,
                workspace: workspace
            )
            return []
        }
    }
}

private extension ChatViewService {
    enum Constants {
        static let throttleIntervalInSeconds = 0.1
        static let local = "local"
    }
}
