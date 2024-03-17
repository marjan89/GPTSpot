//
//  View+Styiling.swift
//  GPTSpot
//
//  Created by Sinisa on 26.2.24..
//

import Foundation
import SwiftUI

extension View {
    
    func roundCorners(radius: CGFloat = 8, stroke: CGFloat = 1, strokeColor: Color = Color.clear) -> some View {
        self
            .clipShape(
                RoundedRectangle(
                    cornerRadius: radius,
                    style: .continuous
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: radius,
                    style: .continuous
                )
                .stroke(strokeColor, lineWidth: strokeColor == Color.clear ? 0 : stroke)
            )
    }
}
