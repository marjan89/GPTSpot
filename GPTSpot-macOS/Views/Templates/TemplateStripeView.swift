//
//  TemplateStripeView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct TemplateStripeView: View {

    enum FocusedTemplateField: Hashable {
        case focusedTemplate(_ template: Template)
    }

    @Environment(\.templateService) private var templateService
    @Query private var templates: [Template]
    @FocusState var focusedTemplateField: FocusedTemplateField?
    private let onTemplateSelected: (Template) -> Void
    private let searchQuery: String

    init(searchQuery: String, onTemplateSelected: @escaping (Template) -> Void) {
        self.onTemplateSelected = onTemplateSelected
        self.searchQuery = searchQuery
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
                    if templates.isEmpty && searchQuery.isEmpty {
                        TemplateItemView(text: String(localized: "Template hint"))
                    } else if templates.isEmpty {
                        TemplateItemView(text: String(localized: "Template search no results"))
                    } else {
                        ForEach(templates, id: \.id) { template in
                            TemplateItemView(text: template.content)
                                .focusable(true)
                                .focused($focusedTemplateField, equals: .focusedTemplate(template))
                                .onTapGesture {
                                    onTemplateSelected(template)
                                }
                                .contextMenu(ContextMenu(menuItems: {
                                    Button {
                                        onTemplateSelected(template)
                                    } label: {
                                        Text("Append to prompt")
                                    }
                                    .keyboardShortcut(.return, modifiers: .control)
                                    Button {
                                        templateService.deleteTemplate(template)
                                    } label: {
                                        Text("Delete")
                                    }
                                    .keyboardShortcut(.delete, modifiers: .control)
                                }))
                        }
                    }
                }
                .padding(4)
            }
            .scrollClipDisabled()
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
                templateService.deleteTemplate(template)
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
        } else if let template = templates.first {
            focusedTemplateField = .focusedTemplate(template)
        }
    }
}

#Preview {

    do {
        let previewer = try Previewer()

        return TemplateStripeView(
            searchQuery: "",
            onTemplateSelected: { _ in
            }
        )
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
