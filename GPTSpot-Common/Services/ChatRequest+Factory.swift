//
//  ChatRequest+Factory.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 9/6/24.
//

import Foundation

extension ChatRequest {

    static func request(with history: [Message]) -> ChatRequest {
        ChatRequest(
            model: UserDefaults.standard.string(forKey: UserDefaults.AIServerKeys.aiModel) ??
            GPTModels.models.first ?? "",
            messages: history,
            temperature: UserDefaults.standard.double(forKey: UserDefaults.AIServerKeys.temperature),
            stream: true
        )
    }

    static func systemRequest() -> ChatRequest {
        ChatRequest(
            model: UserDefaults.standard.string(forKey: UserDefaults.AIServerKeys.aiModel) ??
            GPTModels.models.first ?? "",
            messages: [Message(
                role: Role.system.rawValue,
                content: UserDefaults.standard.string(forKey: UserDefaults.AIServerKeys.systemMessage) ?? ""
            )],
            temperature: UserDefaults.standard.double(forKey: UserDefaults.AIServerKeys.temperature),
            stream: false
        )
    }
}
