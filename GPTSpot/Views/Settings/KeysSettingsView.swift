//
//  KeysSettingsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/19/24.
//

import Foundation
import SwiftUI

struct KeysSettingsView: View {
    
    var body: some View {
        HStack {
            Text("Click to record a key sequence")
            KeyRecordingView()
        }
    }
}

#Preview {
    KeysSettingsView()
}
