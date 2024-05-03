//
//  ChatRequest.swift
//  helper
//
//  Created by Dejan Bekic on 15.2.24..
//

import Foundation

struct ChatRequest: Codable {
    struct Message: Codable {
        let role: String
        let content: String
    }

    let model: String
    let messages: [Message]
    let temperature: Double
    let stream: Bool
}

extension ChatRequest {
    static func request(with history: [Message]) -> ChatRequest {
        ChatRequest(
            model: UserDefaults.standard.string(forKey: AIServerDefaultsKeys.aiModel) ?? "",
            messages: history,
            temperature: UserDefaults.standard.double(forKey: AIServerDefaultsKeys.temperature),
            stream: true
        )
    }
}
