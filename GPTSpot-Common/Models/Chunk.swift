//
//  Chunk.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/16/24.
//

import Foundation

public struct Chunk: Decodable {
    // swiftlint:disable nesting
    struct Choice: Decodable {
        struct Delta: Decodable {
            let role: String?
            let content: String?
        }

        let delta: Delta
    }

    // swiftlint:enable nesting
    let choices: [Choice]
    let id: String
}
