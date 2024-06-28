//
//  ServiceModule.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import GPTSpot_Common
import SwiftData

struct ServiceModule: Module {

    public var dependencies: [ObjectIdentifier: Any] = [:]

    init(with container: Container) throws {
        let modelContext = container.resolve(ModelContext.self)
        let workspaceHomeService = WorkspaceHomeService(modelContext: modelContext)

        dependencies[ObjectIdentifier(WorkspaceHomeService.self)] = workspaceHomeService
    }
}
