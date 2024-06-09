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
