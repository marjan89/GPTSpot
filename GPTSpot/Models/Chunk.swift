//
//  Chunk.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/16/24.
//

import Foundation

struct Chunk: Decodable {
    struct Choice: Decodable {
        struct Delta: Decodable {
            let role: String?
            let content: String?
        }
        
        let delta: Delta
    }
    
    let choices: [Choice]
    let id: String
}
