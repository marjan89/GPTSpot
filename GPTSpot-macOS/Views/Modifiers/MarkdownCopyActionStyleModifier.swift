//
//  MarkdownActionStyleModifier.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 2/7/24.
//

import Foundation
import MarkdownUI
import SwiftUI

struct MarkdownCopyActionStyleModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .markdownBlockStyle(\.codeBlock) { configuration in
                VStack(alignment: .listRowSeparatorTrailing, spacing: .zero) {
                    configuration.label
                        .relativeLineSpacing(.em(0.25))
                        .markdownTextStyle {
                            FontFamilyVariant(.monospaced)
                            FontSize(.em(0.85))
                            FontWeight(.bold)
                            ForegroundColor(.white)
                        }
                        .markdownMargin(top: .zero, bottom: .zero)
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 4)
                    Button("Copy") {
                        configuration.content.copyTextToClipboard()
                    }
                }
                .padding(.all, 4)
                .background(Color.black.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.bottom)
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

    func markdownCopyActionStyle() -> some View {
        return self.modifier(MarkdownCopyActionStyleModifier())
    }
}
