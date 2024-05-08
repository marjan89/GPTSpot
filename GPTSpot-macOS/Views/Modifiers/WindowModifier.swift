//
//  Windowed.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 5/8/24.
//

import Foundation
import SwiftUI
import GPTSpot_Common

struct WindowModifier: ViewModifier {

    func body(content: Content) -> some View {
        if UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.windowed) {
            content
        } else {
            content
                .roundedCorners(radius: 16, strokeColor: Color.black)
                .padding(.all, 20)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.66), radius: 10)
        }
    }
}

extension View {
    func window() -> some View {
        self.modifier(WindowModifier())
    }
}
