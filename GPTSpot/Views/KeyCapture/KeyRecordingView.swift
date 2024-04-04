//
//  KeyCaptureView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 4/4/24.
//
import Foundation
import SwiftUI

struct KeyRecordingView: View {
    @State var keySequence: KeySequence = KeySequence(hotKey: " ", modifiers: EventModifiers())
    @State var keyRecordingState: KeyRecordingState = .idle
    
    var body: some View {
        ZStack {
            KeyCaptureView { keySequence in
                self.keySequence = keySequence
            } recordingAction: { keyRecordingState in
                print(keyRecordingState)
                self.keyRecordingState = keyRecordingState
            }
            Text($keySequence.wrappedValue.asString())
        }
        .background(keyRecordingState == .idle ? Color.black.opacity(0.5) : Color.orange.opacity(0.5))
    }
}
