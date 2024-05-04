//
//  Template.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import Foundation
import SwiftData

@Model
public class Template {
    public var content: String = ""

    public init(content: String) {
        self.content = content
    }
}
