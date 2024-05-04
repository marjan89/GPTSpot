//
//  KeySequence.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/5/24.
//

import Foundation
import SwiftUI

struct KeySequence {
    let hotKey: KeyEquivalent
    let modifiers: EventModifiers

    func asString() -> String {
        var keySequenceString = ""
        if modifiers.contains(.command) {
            keySequenceString += "⌘"
        }
        if modifiers.contains(.shift) {
            keySequenceString += "⇧"
        }
        if modifiers.contains(.control) {
            keySequenceString += "⌃"
        }
        if modifiers.contains(.option) {
            keySequenceString += "⌥"
        }
        keySequenceString += String(hotKey.character)
        return keySequenceString
    }
}
