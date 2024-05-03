//
//  AppKitKeyCaptureView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/5/24.
//

import Foundation
import SwiftUI
import AppKit

fileprivate class AppKitKeyCaptureView: NSView {
    var keySequence: ((KeySequence) -> Void)?
    var keyRecordingAction: ((KeyRecordingState) -> Void)?
    
    private var hotKey: Character = " "
    private var modifiers: EventModifiers = EventModifiers()
    private var recording: KeyRecordingState = .idle
    
    override var acceptsFirstResponder: Bool { true }
    
    override func mouseDown(with event: NSEvent) {
        recording = .recording
        hotKey = " "
        modifiers = EventModifiers()
        keySequence?(KeySequence(hotKey: .init(hotKey), modifiers: modifiers))
        keyRecordingAction?(recording)
    }
    
    override func keyDown(with event: NSEvent) {
        hotKey = event.charactersIgnoringModifiers?.first ?? " "
        recording = .idle
        keyRecordingAction?(recording)
        keySequence?(
            KeySequence(
                hotKey: .init(hotKey),
                modifiers: modifiers
            )
        )
    }
    
    override func flagsChanged(with event: NSEvent) {
        if recording != .recording {
            return
        }
        modifiers = event.mapToEventModifiers()
        keySequence?(
            KeySequence(
                hotKey: .init(hotKey),
                modifiers: modifiers
            )
        )
    }
}

fileprivate extension NSEvent {
    func mapToEventModifiers() -> EventModifiers {
        var modifiers = EventModifiers()
        if self.modifierFlags.contains(.shift) {
            modifiers.insert(.shift)
        }
        if self.modifierFlags.contains(.control) {
            modifiers.insert(.control)
        }
        if self.modifierFlags.contains(.option) {
            modifiers.insert(.option)
        }
        if self.modifierFlags.contains(.command) {
            modifiers.insert(.command)
        }
        return modifiers
    }
}

fileprivate struct KeyCaptureViewRepresentable: NSViewRepresentable {
    var keySequence: ((KeySequence) -> Void)
    var keyRecordingAction: ((KeyRecordingState) -> Void)
    
    func makeNSView(context: Context) -> AppKitKeyCaptureView {
        let view = AppKitKeyCaptureView()
        view.keySequence = keySequence
        view.keyRecordingAction = keyRecordingAction
        return view
    }
    
    func updateNSView(_ nsView: AppKitKeyCaptureView, context: Context) {
    }
}

struct KeyCaptureView: View {
    
    var onKeyDown: (KeySequence) -> Void
    var recordingAction: (KeyRecordingState) -> Void
    
    var body: some View {
        KeyCaptureViewRepresentable(keySequence: onKeyDown, keyRecordingAction: recordingAction)
            .frame(width: 100, height: 20)
            .border(Color.gray, width: 1)
            .focusable()
    }
}
