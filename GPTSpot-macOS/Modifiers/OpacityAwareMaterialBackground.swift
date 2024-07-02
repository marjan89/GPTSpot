//
//  OpacityAwareMaterialBackground.swift
//  GPTSpot-macOS
//
//  Created by Sinisa Marjanovic on 2/7/24.
//

import Foundation
import SwiftUI

struct OpacityAwareMaterialBackgroundModifier: ViewModifier {

    @AppStorage(UserDefaults.GeneralSettingsKeys.panelTransparency) var panelTransparency = 1.0
    @AppStorage(UserDefaults.GeneralSettingsKeys.usePanelTransparency) var usePanelTransparency = false

    func body(content: Content) -> some View {
        if panelTransparency < 1.0 && usePanelTransparency {
            content
                .background(.background.opacity(panelTransparency))
        } else {
            content
                .background(.regularMaterial)
        }
    }
}

extension View {
    func opacityAwareMaterialBackground() -> some View {
        self.modifier(OpacityAwareMaterialBackgroundModifier())
    }
}
