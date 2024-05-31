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

    @Query private var templates: [Template]
    @Environment(\.modelContext) private var modelContext: ModelContext
    private var onTemplateSelected: (Template) -> Void
    @State var templatesQuery: String = ""
    @Environment(\.dismiss) private var dismiss

    init(onTemplateSelected: @escaping (Template) -> Void) {
        self.onTemplateSelected = onTemplateSelected
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
                            modelContext.delete(template)
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
    do {
        let previewer = try Previewer()

        return TemplateList { _ in

        }
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
