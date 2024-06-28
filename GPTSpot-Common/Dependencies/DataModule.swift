//
//  DataModule.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import SwiftData

struct DataModule: Module {

    public var dependencies: [ObjectIdentifier: Any] = [:]

    init(with container: Container) throws {
        let modelContainer = try ModelContainer(for: ChatMessage.self, Template.self)
        let modelContext = ModelContext(modelContainer)

        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Application Support Directory: \(appSupportURL.path)")
        }

        dependencies[ObjectIdentifier(ModelContainer.self)] = modelContainer
        dependencies[ObjectIdentifier(ModelContext.self)] = modelContext
    }
}
