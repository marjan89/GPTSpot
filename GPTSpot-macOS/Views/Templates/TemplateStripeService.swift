//
//  TemplateStripeService.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 7/6/24.
//

import Foundation
import SwiftData
import GPTSpot_Common

@Observable
final class TemplateStripeService {

    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func deleteTemplate(_ template: Template) {
        modelContext.delete(template)
    }
}
