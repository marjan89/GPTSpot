//
//  OpenAIService.swift
//  helper
//
//  Created by Dejan Bekic on 15.2.24..
//

import Foundation
import SwiftUI

enum Message {
    case response(chunk: String, id: String)
    case terminator
    case error(_ error: MessageErrorType)
}

enum MessageErrorType {
    case invalidToken
    case invalidRegion
    case rateLimitReached
    case serverError
    case serverOverload
    case modelUnavailable
    case userCanceled
    case unknown(_ message: String)
    case none
}

public class OpenAIService {

    private var task: Task<Void, Never>?

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

    func completion(for chatRequest: ChatRequest) async throws -> AsyncStream<Message> {
        let chatRequest = try createRequest(for: chatRequest)
        logRequest(chatRequest)

        let (stream, response) = try await URLSession.shared.bytes(for: chatRequest)
        logResponse(response)

        return AsyncStream { continuation in
            task = Task {
                if response.hasErrorStatusCode() {
                    let error = parseError(urlResponse: response)
                    logResponse(response, error: error)
                    continuation.yield(error)
                } else {
                    do {
                        for try await line in stream.lines {
                            let message = parseRawResponse(line)
                            logResponse(response, message: message)
                            continuation.yield(message)
                        }
                    } catch let error as NSError where error.code == NSURLErrorCancelled {
                        let messageError = Message.error(.userCanceled)
                        logResponse(response, error: messageError)
                        continuation.yield(messageError)
                    } catch {
                        let messageError = Message.error(.unknown(error.localizedDescription))
                        logResponse(response, error: messageError)
                        continuation.yield(messageError)
                    }
                }
                continuation.finish()
            }
        }
    }

    @discardableResult func request(for chatRequest: ChatRequest) async throws -> ChatCompletion {
        let request = try createRequest(for: chatRequest)
        logRequest(request)

        let (data, response) = try await URLSession.shared.data(for: request)
        logResponse(response)
        return try Self.decoder.decode(ChatCompletion.self, from: data)
    }

    func cancelCompletion() {
        task?.cancel()
    }

    private func parseError(urlResponse: URLResponse) -> Message {
        if let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            let error = switch statusCode {
            case 401:
                Message.error(.invalidToken)
            case 403:
                Message.error(.invalidRegion)
            case 429:
                Message.error(.rateLimitReached)
            case 500:
                Message.error(.serverError)
            case 503:
                Message.error(.serverOverload)
            case 404:
                Message.error(.modelUnavailable)
            default:
                Message.error(.unknown("Response error: status code: \(statusCode)"))
            }
            return error
        } else {
            return .error(.none)
        }
    }

    private func createRequest(for chatRequest: ChatRequest) throws -> URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let apiKey = UserDefaults.standard.string(forKey: UserDefaults.AIServerKeys.openAiKey) ?? ""
        let request = try {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpBody = try Self.encoder.encode(chatRequest)
            return request
        }()

        return request
    }

    private func parseRawResponse(_ line: String) -> Message {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else {
            return .error(.unknown("Response error: data missing"))
        }

        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

        if message == "[DONE]" {
            return .terminator
        }
        guard let chunk = try? JSONDecoder().decode(Chunk.self, from: message.data(using: .utf8)!) else {
            return .error(.unknown("Response error: decoding chunk failed"))
        }
        return .response(chunk: chunk.choices.first?.delta.content ?? "", id: chunk.id)
    }

    // swiftlint:disable non_optional_string_data_conversion
    private func logRequest(_ request: URLRequest) {
        print("Request URL: \(request.url?.absoluteString ?? "Unknown URL")")
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
    }
    // swiftlint:enable non_optional_string_data_conversion

    private func logResponse(_ response: URLResponse, message: Message? = nil, error: Message? = nil) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
        }
        if let message = message {
            print("Response Message: \(message)")
        }
        if let error = error {
            print("Response Error: \(error)")
        }
    }
}
