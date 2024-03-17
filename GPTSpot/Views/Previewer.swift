//
//  Previewer.swift
//  FaceFacts
//
//  Created by Sinisa on 25.2.24..
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let chatMessages: [ChatMessage]

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: ChatMessage.self,
            configurations: config
        )

        chatMessages = [
            ChatMessage(content: "Hello world", origin: "user", timestamp: 0, id: ""),
            ChatMessage(content: "Hello", origin: "assistant", timestamp: 0, id: "")
        ]

        for message in chatMessages {
            container.mainContext.insert(message)
        }
    }
}
