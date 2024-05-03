//
//  URLResponse+ErrorCode.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 5/2/24.
//

import Foundation

internal extension URLResponse {
    func hasErrorStatusCode() -> Bool {
        if let statusCode = (self as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            return true
        } else {
            return false
        }
    }
}
