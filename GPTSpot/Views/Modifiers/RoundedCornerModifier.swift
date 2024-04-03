//
//  RoundedCornerModifier.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/1/24.
//

import SwiftUI

struct RoundedCornerModifier: ViewModifier {
    var radius: CGFloat = 8
    var strokeWidth: CGFloat = 1
    var strokeColor: Color = Color.clear
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(strokeColor, lineWidth: strokeColor == Color.clear ? 0 : strokeWidth)
            )
    }
}

extension View {
    
    func roundedCorners(radius: CGFloat = 8, stroke: CGFloat = 1, strokeColor: Color = Color.clear) -> some View {
        return self
            .modifier(RoundedCornerModifier(radius: radius, strokeWidth: stroke, strokeColor: strokeColor))
    }
}
