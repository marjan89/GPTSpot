//
//  TemplateService.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 11/6/24.
//

import Foundation
import SwiftData

@Observable
public class TemplateService {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func insertTemplate(for content: String) {
        modelContext.insert(Template(content: content))
    }

    public func insertTemplate(_ template: Template) {
        modelContext.insert(template)
    }

    public func deleteTemplate(_ template: Template) {
        modelContext.delete(template)
    }
}
