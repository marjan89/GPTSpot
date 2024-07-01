//
//  HotkeyAction.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 2/27/24.
//

import SwiftUI

struct HotkeyAction: View {
    private let hotkey: KeyEquivalent
    private let eventModifiers: EventModifiers
    private let action: () -> Void

    init(hotkey: KeyEquivalent, eventModifiers: EventModifiers = .command, action: @escaping () -> Void) {
        self.hotkey = hotkey
        self.eventModifiers = eventModifiers
        self.action = action
    }

    var body: some View {
        Button(action: action) {  }
            .keyboardShortcut(hotkey, modifiers: eventModifiers)
            .frame(width: 0, height: 0)
            .selectionDisabled()
            .focusable(false)
            .hidden()
    }
}
