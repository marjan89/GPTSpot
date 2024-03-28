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
    let templates: [Template]

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: ChatMessage.self, Template.self,
            configurations: config
        )

        chatMessages = [
            ChatMessage(content: "Hello world", origin: "user", timestamp: 0, id: "", workspace: 1),
            ChatMessage(content: "Hello", origin: "assistant", timestamp: 0, id: "", workspace: 1)
        ]
        
        templates = [
            Template(content: "Lorem ipsum"),
            Template(content: "Dolor sit amet"),
            Template(content: "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos")
        ]

        for message in chatMessages {
            container.mainContext.insert(message)
        }
        for template in templates {
            container.mainContext.insert(template)
        }
    }
}
