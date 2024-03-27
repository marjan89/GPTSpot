//
//  TemplateItemView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import SwiftUI
import MarkdownUI

struct TemplateItemView: View {
    
    let text: String
    
    var body: some View {
        ZStack {
            Markdown(text)
                .gptStyle()
                .padding(8)
                .multilineTextAlignment(.leading)
                .scrollContentBackground(.hidden)
                .frame(idealWidth: 240, maxHeight: 180, alignment: .topLeading)
        }
        .background(.blue)
        .roundCorners(radius: 8)
    }
}

#Preview {
    TemplateItemView(text: "Lorem ipsum dolor sit amet")
}
