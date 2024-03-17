//
//  ChatCompletion.swift
//  helper
//
//  Created by Dejan Bekic on 15.2.24..
//

import Foundation

struct ChatCompletion: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }

        let index: Int
        let message: Message
        let logprobs: String?
        let finishReason: String
    }

    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }

    let object: String
    let created: Int
    let id: String
    let model: String
    let choices: [Choice]
    let usage: Usage
}
