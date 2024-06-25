//
//  TemplateService.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 11/6/24.
//

import Foundation
import SwiftData
import SwiftUI

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

public struct TemplateServiceKey: EnvironmentKey {
    public static let defaultValue: TemplateService = Container.shared.resolve(TemplateService.self)
}

extension EnvironmentValues {
    public var templateService: TemplateService {
        get { self[TemplateServiceKey.self] }
        set { self[TemplateServiceKey.self] = newValue }
    }
}
