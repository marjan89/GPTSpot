//
//  PromptEditor.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import SwiftUI

public struct PromptEditor: View {
    
    @Binding var showTemplateHint: Bool
    @Binding var templateSearchQuery: String
    @Binding var prompt: String
    @FocusState var focusedField: Bool
    
    let textEditorHeight: CGFloat
    
    public init(showTemplateHint: Binding<Bool>, templateSearchQuery: Binding<String>, prompt: Binding<String>, focusedField: FocusState<Bool>, textEditorHeight: CGFloat) {
        self._showTemplateHint = showTemplateHint
        self._templateSearchQuery = templateSearchQuery
        self._prompt = prompt
        self._focusedField = focusedField
        self.textEditorHeight = textEditorHeight
    }
    
    public var body: some View {
        ZStack {
            if showTemplateHint && templateSearchQuery.isEmpty {
                Text("Search templates")
                    .padding(.top, 6)
                    .padding(.leading, 16)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: textEditorHeight, alignment: .topLeading)
            }
            if !showTemplateHint && prompt.isEmpty {
                Text("Send a message")
                    .padding(.top, 6)
                    .padding(.leading, 16)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: textEditorHeight, alignment: .topLeading)
            }
            TextEditor(text: showTemplateHint ? $templateSearchQuery : $prompt)
                .padding(.all, 8)
                .accessibilityHidden(true)
                .scrollClipDisabled()
                .scrollContentBackground(.hidden)
                .scrollIndicators(.never)
                .focused($focusedField)
                .onAppear {
                    focusedField = true
                }
                .roundedCorners(strokeColor: .gray)
                .frame(height: textEditorHeight)
            HotkeyAction(hotkey: .init("`"), eventModifiers: .command) {
                prompt.append("```")
            }
        }
    }
}

#Preview {
    
    @State var showTemplateHint = false
    @State var templateSearchQuery = ""
    @State var prompt = "Hello"
    @FocusState var focusedField: Bool
    let textEditorHeight = 100.0
    
    return PromptEditor(
        showTemplateHint: $showTemplateHint,
        templateSearchQuery: $templateSearchQuery,
        prompt: $prompt,
        focusedField: _focusedField,
        textEditorHeight: textEditorHeight
    )
}
