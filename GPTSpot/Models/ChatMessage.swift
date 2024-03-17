//
//  ChatMessage.swift
//  GPTSpot
//
//  Created by Sinisa on 27.2.24..
//

import Foundation
import SwiftData

enum Role: String {
    case user = "user"
    case assistant = "assistant"

    static func fromRaw(_ rawValue: String) -> Role {
        return rawValue == "user" ? .user : .assistant
    }
}

@Model
class ChatMessage {
    var content: String = ""
    var origin: String = Role.assistant.rawValue
    var timestamp: Double = 0
    var id = ""

    init(content: String, origin: String, timestamp: Double, id: String) {
        self.content = content
        self.origin = origin
        self.timestamp = timestamp
        self.id = id
    }
}
