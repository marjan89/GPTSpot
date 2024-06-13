//
//  Previewer.swift
//  FaceFacts
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import SwiftData

@MainActor
public struct Previewer {

    public let container: ModelContainer
    public let openAIService: OpenAIService
    public let chatViewService: ChatViewService
    public let chatMessageService: ChatMessageService

    public init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        container = try ModelContainer(
            for: ChatMessage.self, Template.self,
            configurations: config
        )

        let chatMessages: [ChatMessage]
        let templates: [Template]
        openAIService = OpenAIServiceKey.defaultValue
        chatMessageService = ChatMessageService(modelContext: container.mainContext)

        chatViewService = ChatViewService(
            modelContext: container.mainContext,
            openAISerice: openAIService,
            chatMessageService: chatMessageService
        )

        chatMessages = produceMockChatMessages()
        templates = produceMockTemplates()

        for message in chatMessages {
            container.mainContext.insert(message)
        }
        for template in templates {
            container.mainContext.insert(template)
        }
    }

    private func produceMockChatMessages() -> [ChatMessage] {
        return [
            ChatMessage(content: "Hello AI", origin: "user", timestamp: 0, id: "0", workspace: 1),
            ChatMessage(
                content: """
                            Hello! How can I assist you today? \
                            If you have any questions or need help \
                            with something, feel free to ask.
                            """,
                origin: "assistant",
                timestamp: 1,
                id: "1",
                workspace: 1
            ),
            ChatMessage(content: "How are you today", origin: "user", timestamp: 2, id: "2", workspace: 1),
            ChatMessage(content: "Im just fine", origin: "assistant", timestamp: 3, id: "3", workspace: 1),
            ChatMessage(content: "Hello on workspace 2", origin: "user", timestamp: 0, id: "4", workspace: 2),
            ChatMessage(content: "Hello", origin: "assistant", timestamp: 1, id: "5", workspace: 2)
        ]
    }

    private func produceMockTemplates() -> [Template] {
        return [
            Template(content: "Curabitur sed iaculis dolor"),
            Template(content: "Nulla facilisi"),
            Template(content: "Donec aliquet mi nec libero fermentum, non ultricies nibh sollicitudin"),
            Template(content: "Praesent nec nisl a purus blandit viverra"),
            Template(content: "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae"),
            Template(content: "Etiam ultricies nisi vel augue"),
            Template(content: "Morbi ac felis"),
            Template(content: "Nunc egestas augue at pellentesque laoreet, sapien eros vestibulum urna, posuere"),
            Template(content: "Vivamus elementum semper nisi"),
            Template(content: "Aenean vulputate eleifend tellus"),
            Template(content: "Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim"),
            Template(content: "Curabitur sed iaculis dolor"),
            Template(content: "Nulla facilisi"),
            Template(content: "Donec aliquet mi nec libero fermentum, non ultricies nibh sollicitudin"),
            Template(content: "Praesent nec nisl a purus blandit viverra"),
            Template(content: "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae"),
            Template(content: "Etiam ultricies nisi vel augue"),
            Template(content: "Morbi ac felis"),
            Template(content: "Nunc egestas augue at pellentesque laoreet, sapien eros vestibulum urna, posuere"),
            Template(content: "Vivamus elementum semper nisi"),
            Template(content: "Aenean vulputate eleifend tellus"),
            Template(content: "Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim")
        ]

    }
}
