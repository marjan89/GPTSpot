//
//  HotkeyAction.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 2/27/24.
//

import SwiftUI

struct HotkeyAction: View {
    let hotkey: KeyEquivalent
    let eventModifiers: EventModifiers
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {  }
            .keyboardShortcut(hotkey, modifiers: eventModifiers)
            .frame(width: 0, height: 0)
            .selectionDisabled()
            .focusable(false)
            .hidden()
    }
}
