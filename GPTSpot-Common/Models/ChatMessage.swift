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
    case system = "system"
}

@Model
class ChatMessage {
    var content: String = ""
    var origin: String = Role.assistant.rawValue
    var timestamp: Double = 0
    var id: String = ""
    var workspace: Int = 1

    init(content: String, origin: String, timestamp: Double, id: String, workspace: Int) {
        self.content = content
        self.origin = origin
        self.timestamp = timestamp
        self.id = id
        self.workspace = workspace
    }
}
