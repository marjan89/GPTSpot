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

    init(onTemplateSelected: @escaping (Template) -> Void) {
        self.onTemplateSelected = onTemplateSelected
    }

    var body: some View {
        List {
            ForEach(templates, id: \.content) { template in
                Text(template.content)
                    .onTapGesture {
                        onTemplateSelected(template)
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
