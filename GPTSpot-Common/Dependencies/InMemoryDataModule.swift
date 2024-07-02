//
//  InMemoryDataModule.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 2/7/24.
//

import Foundation
import SwiftData

public struct InMemoryDataModule: Module {

    public var dependencies: [ObjectIdentifier: Any] = [:]

    public init(with container: Container) throws {
        let modelContainer = try ModelContainer(
            for: ChatMessage.self, Template.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = ModelContext(modelContainer)

        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Application Support Directory: \(appSupportURL.path)")
        }

        dependencies[ObjectIdentifier(ModelContainer.self)] = modelContainer
        dependencies[ObjectIdentifier(ModelContext.self)] = modelContext
    }
}
