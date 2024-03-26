//
//  TemplateStripeView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import SwiftUI
import SwiftData

struct TemplateStripeView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(ChatViewService.self) var chatViewService
    @Query private var templates: [Template]
    
    init(searchQuery: String) {
        _templates = Query(
            filter: #Predicate<Template> { template in
                searchQuery.isEmpty || template.content.contains(searchQuery)
            }
        )
    }
    
    func filter(searchQuery: String, template: String) -> Bool {
        searchQuery
            .split(separator: " ")
            .reduce(
                true,
                { result, string in
                    result && template.contains(string)
                }
            )
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(templates, id: \.self) { template in
                    TemplateItemView(text: template.content)
                        .padding(.trailing, 8)
                        .contextMenu(ContextMenu(menuItems: {
                            Button {
                                chatViewService.setTemplateAsPrompt(template: template)
                            } label: {
                                Text("Make prompt")
                            }
                            Button {
                                chatViewService.deleteTemplate(template)
                            } label: {
                                Text("Delete")
                            }
                        }))
                }
            }
        }
        .scrollIndicators(.hidden)
        .roundCorners(radius: 8)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return TemplateStripeView(searchQuery: "")
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
