//
//  CheatSheetView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/28/24.
//

import SwiftUI

struct CheatSheetView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("General")
                    .font(.headline)
                Text("**⌘d** discard history")
                Text("**⌘↑** last prompt")
                Text("**⌘⏎** send")
                Text("**⇧⌘⏎** discard history and send")
                Text("**⇧⌃Space** show/hide")
                Text("**⌘t** templates")
                Text("**⌘.** show stats")
                Text("**⌘?** show help")
                Spacer()
            }
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text("Messages")
                    .font(.headline)
                Text("**⌘k** message up")
                Text("**⌘j** message down")
                Text("**⌥⏎** make prompt")
                Text("**⌘⌫** delete message")
                Text("**⌘c** copy message")
                Text("**⌘s** save as template")
                Spacer()
            }
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text("Templates")
                    .font(.headline)
                Text("**⌘[** next prompt")
                Text("**⌘]** previous prompt")
                Text("**⌥⏎** make prompt")
                Text("**⌘⌫** delete prompt")
                Spacer()
            }
        }
    }
}

#Preview {
    CheatSheetView()
}
