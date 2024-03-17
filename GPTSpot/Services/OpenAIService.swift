//
//  OpenAIService.swift
//  helper
//
//  Created by Dejan Bekic on 15.2.24..
//

import Foundation

enum Message {
    case response(chunk: String, id: String)
    case terminator
    case error
}

struct OpenAIService {
    private var session = URLSession.shared
    
    private static var decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private static var encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func completion(for chatRequest: ChatRequest, with responseHandler: @escaping @MainActor (Message) -> Void) async throws {
        Task {
            let chatRequest = try createRequest(for: chatRequest)
            let (stream, _) = try await URLSession.shared.bytes(for: chatRequest)
            
            for try await line in stream.lines {
                await responseHandler(parseRawResponse(line))
            }
        }
    }
    
    private func createRequest(for chatRequest: ChatRequest) throws -> URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.httpBody = try Self.encoder.encode(chatRequest)
        
        return request
    }
    
    private func parseRawResponse(_ line: String) -> Message {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else { return .error }
        
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        if message == "[DONE]" {
            return .terminator
        }
        guard let chunk = try? JSONDecoder().decode(Chunk.self, from: message.data(using: .utf8)!) else {
            return .error
        }
        return .response(chunk: chunk.choices.first?.delta.content ?? "", id: chunk.id)
    }
}
