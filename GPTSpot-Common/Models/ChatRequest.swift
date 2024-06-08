//
//  ChatRequest.swift
//  helper
//
//  Created by Dejan Bekic on 15.2.24..
//

import Foundation

public struct ChatRequest: Codable {
    public struct Message: Codable {
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
            model: UserDefaults.standard.string(forKey: AIServerDefaultsKeys.aiModel) ?? GPTModels.models.first ?? "",
            messages: history,
            temperature: UserDefaults.standard.double(forKey: AIServerDefaultsKeys.temperature),
            stream: true
        )
    }

    static func systemRequest() -> ChatRequest {
        ChatRequest(
            model: UserDefaults.standard.string(forKey: AIServerDefaultsKeys.aiModel) ?? GPTModels.models.first ?? "",
            messages: [Message(
                role: Role.system.rawValue,
                content: UserDefaults.standard.string(forKey: AIServerDefaultsKeys.promptPrefix) ?? ""
            )],
            temperature: UserDefaults.standard.double(forKey: AIServerDefaultsKeys.temperature),
            stream: false
        )
    }
}
