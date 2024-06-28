//
//  GPTSpot_iOSApp.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

@main
struct GPTSpotiOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(Container.shared.resolve(ModelContainer.self))
        }
    }
}
