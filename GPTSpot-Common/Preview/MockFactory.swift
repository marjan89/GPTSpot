//
//  MockFactory.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 2/7/24.
//

import Foundation

enum MockFactory {

    public static func produceMockChatMessages() -> [ChatMessage] {
        return [
            ChatMessage(
                content: "Hello",
                origin: Role.user.rawValue,
                timestamp: 1,
                id: "1",
                workspace: 1
            ),
            ChatMessage(
                content: "Hi!",
                origin: Role.assistant.rawValue,
                timestamp: 2,
                id: "2",
                workspace: 1
            ),
            ChatMessage(
                content: "Response error",
                origin: Role.local.rawValue,
                timestamp: 3,
                id: "3",
                workspace: 1
            ),
            ChatMessage(
                content: "System message",
                origin: Role.system.rawValue,
                timestamp: 3,
                id: "4",
                workspace: 1
            )
        ]
    }

    public static func produceMockTemplates() -> [Template] {
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
