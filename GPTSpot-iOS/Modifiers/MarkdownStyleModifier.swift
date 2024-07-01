//
//  Markdown+Styling.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/26/24.
//

import Foundation
import MarkdownUI
import SwiftUI

struct MarkdownStyleModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .markdownBlockStyle(\.codeBlock) { configuration in
                configuration.label
                    .relativeLineSpacing(.em(0.25))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                        FontWeight(.bold)
                        ForegroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .markdownMargin(top: .zero, bottom: .em(0.8))
            }
            .markdownTextStyle(\.code) {
                FontFamilyVariant(.monospaced)
                FontWeight(.bold)
                BackgroundColor(Color.black.opacity(0.2))
                ForegroundColor(.white)
            }
            .markdownTextStyle(\.text) {
                ForegroundColor(.white)
            }
    }
}

public extension Markdown {

    func markdownStyle() -> some View {
        self.modifier(MarkdownStyleModifier())
    }
}
