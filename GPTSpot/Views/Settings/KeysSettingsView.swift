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
        Form {
            Text("**⌘d** discard history")
            Text("**⌘↑** last prompt")
            Text("**⌘↩** send")
            Text("**⌘⇧↩** discard history and send")
            Text("**⇧⌃Space** show/hide")
        }
        .padding(20)
        .frame(width: 300, height: 150)
    }
}
