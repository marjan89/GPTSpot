//
//  ChatView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI
import GPTSpot_Common

struct ChatView: View {
    @Bindable var chatViewService: ChatViewService
    @State var showTemplateStripe = false
    @State var templateSearchQuery = ""

    @FocusState private var focusedField: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                ChatListView(
                    workspace: 0,
                    prompt: $chatViewService.prompt
                )
                VStack {
                    VStack {
                        if showTemplateStripe {
                            TemplateStripeView(
                                searchQuery: templateSearchQuery,
                                onTemplateSelected: { template in
                                    chatViewService.prompt = template.content
                                    focusedField = true
                                    showTemplateStripe = false
                                    templateSearchQuery = ""
                                }
                            )
                            .frame(height: 196)
                        }
                        PromptEditor(
                            showTemplateHint: $showTemplateStripe,
                            templateSearchQuery: $templateSearchQuery,
                            prompt: $chatViewService.prompt,
                            focusedField: _focusedField,
                            textEditorHeight: geometry.size.height / 8
                        )
                    }
                    .padding(.all, 16)
                }
                .background(.regularMaterial)
            }
        }
        .background(.windowBackground)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ChatView(chatViewService: .init(
            modelContext: previewer.container.mainContext,
            openAISerice: OpenAIServiceKey.defaultValue)
        )
        .frame(width: 700, height: 600)
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
