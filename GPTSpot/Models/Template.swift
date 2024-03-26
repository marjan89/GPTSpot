//
//  Template.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import Foundation
import SwiftData

@Model
class Template {
    var content: String = ""
    
    init(content: String) {
        self.content = content
    }
}
