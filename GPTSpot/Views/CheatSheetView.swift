//
//  CheatSheetView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/28/24.
//

import SwiftUI

struct CheatSheetView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                Text("General")
                    .font(.headline)
                Text("**⇧⌃Space** show/hide")
                Text("**⌘T** templates")
                Text("**⌘.** show stats")
                Text("**⌘?** show help")
            }
            VStack(alignment: .leading) {
                Text("Chat")
                    .font(.headline)
                Text("**⌘D** discard history")
                Text("**⌘↑** last prompt")
                Text("**⌘⏎** send")
                Text("**⇧⌘⏎** cancel response")
            }
            VStack(alignment: .leading) {
                Text("Messages")
                    .font(.headline)
                Text("**⌘K** message up")
                Text("**⌘J** message down")
                Text("**⌥⏎** make prompt")
                Text("**⌥⌫** delete message")
                Text("**⌥C** copy message")
                Text("**⌥S** save as template")
            }
            VStack(alignment: .leading) {
                Text("Templates")
                    .font(.headline)
                Text("**⌘[** next prompt")
                Text("**⌘]** previous prompt")
                Text("**^⏎** make prompt")
                Text("**^⌫** delete prompt")
            }
        }
    }
}

#Preview {
    CheatSheetView()
}
