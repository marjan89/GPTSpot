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
        case focusedTemplate(_ template: Template)
    }
    
    private var onTemplateSelected: (Template) -> Void
    
    @Query private var templates: [Template]
    
    @Environment(\.modelContext) var modelContext: ModelContext
    
    @FocusState var focusedTemplateField: FocusedTemplateField?
    
    init(searchQuery: String, onTemplateSelected: @escaping (Template) -> Void) {
        self.onTemplateSelected = onTemplateSelected
        _templates = Query(
            filter: #Predicate<Template> { template in
                searchQuery.isEmpty || template.content.contains(searchQuery)
            }
        )
    }
    
    var body: some View {
        ZStack {
            hotkeys()
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(templates, id: \.content) { template in
                        TemplateItemView(text: template.content)
                            .focusable(true)
                            .focused($focusedTemplateField, equals: .focusedTemplate(template))
                            .contextMenu(ContextMenu(menuItems: {
                                Button {
                                    onTemplateSelected(template)
                                } label: {
                                    Text("Make prompt")
                                }
                                .keyboardShortcut(.return, modifiers: .control)
                                Button {
                                    modelContext.delete(template)
                                } label: {
                                    Text("Delete")
                                }
                                .keyboardShortcut(.delete, modifiers: .control)
                            }))
                    }
                }
                .padding(4)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private func hotkeys() -> some View {
        HotkeyAction(hotkey: .init("]")) {
            focusMessage(.next)
        }
        HotkeyAction(hotkey: .init("[")) {
            focusMessage(.previous)
        }
        HotkeyAction(hotkey: .delete, eventModifiers: .control) {
            if case let .focusedTemplate(template) = focusedTemplateField {
                modelContext.delete(template)
            }
        }
        HotkeyAction(hotkey: .return, eventModifiers: .control) {
            if case let .focusedTemplate(template) = focusedTemplateField {
                onTemplateSelected(template)
            }
        }
    }
    
    private func focusMessage(_ direction: FocusDirection) {
        if case let .focusedTemplate(focusedTemplate) = focusedTemplateField {
            let index = templates.firstIndex(of: focusedTemplate) ?? 0
            let newTemplateIndex = switch direction {
            case .next:
                min(index + 1, templates.count - 1)
            case .previous:
                max(index - 1, 0)
            }
            focusedTemplateField = .focusedTemplate(templates[newTemplateIndex])
        } else if let template = templates.first  {
            focusedTemplateField = .focusedTemplate(template)
        }
    }
}

#Preview {
    return TemplateStripeView(
        searchQuery: "",
        onTemplateSelected: { template in
        }
    )
}
