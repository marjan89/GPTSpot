//
//  ChatMessage.swift
//  GPTSpot
//
//  Created by Sinisa on 27.2.24..
//

import Foundation
import SwiftData

public enum Role: String {
    case user
    case assistant
    case system
}

@Model
public class ChatMessage {
    public var content: String = ""
    public var origin: String = Role.assistant.rawValue
    public var timestamp: Double = 0
    public var id: String = ""
    public var workspace: Int = 1

    public init(content: String, origin: String, timestamp: Double, id: String, workspace: Int) {
        self.content = content
        self.origin = origin
        self.timestamp = timestamp
        self.id = id
        self.workspace = workspace
    }
}
