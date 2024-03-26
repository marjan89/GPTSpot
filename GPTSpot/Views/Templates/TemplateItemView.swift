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
                .multilineTextAlignment(.leading)
                .padding(8)
                .frame(width: 240, height: 180, alignment: .topLeading)
                .scrollContentBackground(.hidden)
        }
        .background(.blue)
        .roundCorners(radius: 8)
    }
}

#Preview {
    TemplateItemView(text: "Lorem ipsum dolor sit amet")
}
