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

    private static var encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    func completion(for chatRequest: ChatRequest) async throws -> AsyncStream<Message> {
        let chatRequest = try createRequest(for: chatRequest)
        let (stream, response) = try await URLSession.shared.bytes(for: chatRequest)
        return AsyncStream { continuation in
            task = Task {
                if response.hasErrorStatusCode() {
                    continuation.yield(parseError(urlResponse: response))
                } else {
                    do {
                        for try await line in stream.lines {
                            continuation.yield(parseRawResponse(line))
                        }
                    } catch let error as NSError where error.code == NSURLErrorCancelled {
                        continuation.yield(.error(.userCanceled))
                    } catch {
                        continuation.yield(.error(.unknown(error.localizedDescription)))
                    }
                }
                continuation.finish()
            }
        }
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
        var request = URLRequest(url: url)
        let apiKey = UserDefaults.standard.string(forKey: AIServerDefaultsKeys.openAiKey) ?? ""
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try Self.encoder.encode(chatRequest)

        return request
    }

    private func parseRawResponse(_ line: String) -> Message {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else {
            return .error(.unknown("Reponse error: data missing"))
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

public struct OpenAIServiceKey: EnvironmentKey {
    public static let defaultValue: OpenAIService = OpenAIService()
}

extension EnvironmentValues {
    public var openAIService: OpenAIService {
        get { self[OpenAIServiceKey.self] }
        set { self[OpenAIServiceKey.self] = newValue }
    }
}
