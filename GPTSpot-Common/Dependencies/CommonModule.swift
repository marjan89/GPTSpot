//
//  CommonModule.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import SwiftData

public struct CommonModule: Module {

    public var dependencies: [ObjectIdentifier: Any] = [:]

    public init(with container: Container) throws {
        let modelContext = container.resolve(ModelContext.self)

        let templateService = configuredTemplateService(modelContext: modelContext)
        let chatMessageService = configuredChatMessageService(modelContext: modelContext)
        let openAiService = configuredOpenAIService()
        let chatViewService = configuredChatViewService(
            modelContext: modelContext,
            openAIService: openAiService,
            chatMessageService: chatMessageService
        )

        dependencies[ObjectIdentifier(TemplateService.self)] = templateService
        dependencies[ObjectIdentifier(ChatMessageService.self)] = chatMessageService
        dependencies[ObjectIdentifier(OpenAIService.self)] = openAiService
        dependencies[ObjectIdentifier(ChatViewService.self)] = chatViewService
    }

    private func configuredTemplateService(modelContext: ModelContext) -> TemplateService {
        TemplateService(modelContext: modelContext)
    }

    private func configuredChatMessageService(modelContext: ModelContext) -> ChatMessageService {
        ChatMessageService(modelContext: modelContext)
    }

    private func configuredOpenAIService() -> OpenAIService {
        OpenAIService()
    }

    private func configuredChatViewService(
        modelContext: ModelContext,
        openAIService: OpenAIService,
        chatMessageService: ChatMessageService
    ) -> ChatViewService {
        ChatViewService(modelContext: modelContext, openAISerice: openAIService, chatMessageService: chatMessageService)
    }
}
