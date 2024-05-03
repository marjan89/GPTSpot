//
//  TemplateItemView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import SwiftUI
import MarkdownUI
import GPTSpot_Common

struct TemplateItemView: View {
    
    let text: String
    
    var body: some View {
        Markdown(text)
            .gptStyle()
            .padding(8)
            .multilineTextAlignment(.leading)
            .scrollContentBackground(.hidden)
            .frame(idealWidth: 240, minHeight: 180, maxHeight: 180, alignment: .topLeading)
            .background(.blue)
            .cornerRadius(8)
    }
}

#Preview {
    TemplateItemView(text: "Lorem ipsum dolor sit amet")
}
