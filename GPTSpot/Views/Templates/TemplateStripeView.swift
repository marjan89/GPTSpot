//
//  TemplateStripeView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import SwiftUI
import SwiftData

struct TemplateStripeView: View {
    
    enum FocusedTemplateField : Hashable {
        case index(_ value: Int)
    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(ChatViewService.self) var chatViewService
    @Query private var templates: [Template]
    
    @FocusState var focusedTemplateField: FocusedTemplateField?
    
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
        ZStack {
            HotkeyAction(hotkey: .init("]")) {
                if case let .index(value) = focusedTemplateField {
                    focusedTemplateField = .index(min(value + 1, templates.count - 1))
                } else {
                    focusedTemplateField = .index(0)
                }
            }
            HotkeyAction(hotkey: .init("[")) {
                if case let .index(value) = focusedTemplateField {
                    focusedTemplateField = .index(max(value - 1, 0))
                } else {
                    focusedTemplateField = .index(0)
                }
            }
            HotkeyAction(hotkey: .delete) {
                if case let .index(value) = focusedTemplateField {
                    chatViewService.deleteTemplate(templates[value])
                }
            }
            HotkeyAction(hotkey: .return, eventModifiers: .option) {
                if case let .index(value) = focusedTemplateField {
                    chatViewService.setTemplateAsPrompt(template: templates[value])
                }
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(templates.indices, id: \.self) { index in
                        TemplateItemView(text: templates[index].content)
                            .focusable(true)
                            .focused($focusedTemplateField, equals: .index(index))
                            .id(index)
                            .contextMenu(ContextMenu(menuItems: {
                                Button {
                                    chatViewService.setTemplateAsPrompt(template: templates[index])
                                } label: {
                                    Text("Make prompt")
                                }
                                Button {
                                    chatViewService.deleteTemplate(templates[index])
                                } label: {
                                    Text("Delete")
                                }
                            }))
                    }
                }
                .padding(4)
            }
            .scrollIndicators(.hidden)
            .roundCorners(radius: 4)
        }
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
