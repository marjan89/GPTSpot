//
//  TemplateItemView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/6/24.
//

import SwiftUI
import MarkdownUI

struct TemplateItemView: View {

    let text: String

    var body: some View {
        Markdown(text)
            .gptStyle()
            .padding(8)
            .multilineTextAlignment(.leading)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.blue)
            .cornerRadius(8)
    }
}

#Preview {
    TemplateItemView(text: "Lorem ipsum dolor sit amet")
}
