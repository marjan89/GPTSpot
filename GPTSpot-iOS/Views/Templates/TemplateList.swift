//
//  TemplateList.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/6/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct TemplateList: View {

    @Environment(\.dismiss) private var dismiss
    @Query private var templates: [Template]
    @State var templatesQuery: String = ""
    private let onTemplateSwipeDelete: (Template) -> Void
    private let onTemplateSelected: (Template) -> Void

    init(
        onTemplateSelected: @escaping (Template) -> Void,
        onTemplateSwipeDelete: @escaping (Template) -> Void
    ) {
        self.onTemplateSelected = onTemplateSelected
        self.onTemplateSwipeDelete = onTemplateSwipeDelete
    }

    var body: some View {
        List {
            ForEach(
                templates.filter { template in
                    if templatesQuery.isEmpty {
                        return true
                    } else {
                        let words = templatesQuery
                            .lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .components(separatedBy: .whitespaces)
                        let queryMatched = words.contains { word in
                            template.content.lowercased().contains(word)
                        }
                        return queryMatched
                    }
                },
                id: \.id
            ) { template in
                Text(template.content)
                    .onTapGesture {
                        onTemplateSelected(template)
                        dismiss()
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            onTemplateSwipeDelete(template)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
            }
        }
        .searchable(text: $templatesQuery)
    }
}

#Preview {
    Previewer {
        TemplateList(
            onTemplateSelected: { _ in },
            onTemplateSwipeDelete: { _ in }
        )
    }
}
