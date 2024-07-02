import Foundation
import SwiftData
import SwiftUI

@MainActor
public struct Previewer<Content: View>: View {

    private var content: Content
    private let container: Container

    public init(@ViewBuilder content: () -> Content) {
        self.container = Container.container(for: InMemoryDataModule.self, CommonModule.self)

        self.content = content()

        let chatMessages: [ChatMessage] = MockFactory.produceMockChatMessages()
        let templates: [Template] = MockFactory.produceMockTemplates()

        let context = container.resolve(ModelContext.self)

        for message in chatMessages {
            context.insert(message)
        }
        for template in templates {
            context.insert(template)
        }
    }

    public var body: some View {
        content
            .modelContainer(container.resolve(ModelContainer.self))
    }
}
