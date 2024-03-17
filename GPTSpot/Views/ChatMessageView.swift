//
//  ChatMessageView.swift
//  GPTSpot
//
//  Created by Sinisa on 27.2.24..
//

import SwiftUI

struct ChatMessageView: View {
    
    let content: String
    let origin: Role
    let spacerWidth: Double
    
    init(content: String, origin: Role, spacerWidth: Double) {
        self.content = content
        self.origin = origin
        self.spacerWidth = spacerWidth
    }
    
    var body: some View {
        HStack {
            if origin == Role.user {
                Spacer()
                    .frame(minWidth: spacerWidth)
            }
            Text(content)
                .foregroundColor(Color(.textColor))
                .textSelection(.enabled)
                .scrollContentBackground(.hidden)
                .padding(.all, 8)
                .background(origin == Role.user ? Color.blue : Color(.unemphasizedSelectedTextBackgroundColor))
                .roundCorners(radius: 8)
                .frame(alignment: origin == .user ? .trailing : .leading)
                .layoutPriority(1)
            if origin == Role.assistant {
                Spacer()
                    .frame(maxWidth: spacerWidth)
                    .layoutPriority(2)
            }
        }
    }
}

#Preview {
    ChatMessageView(content: "Hello, this is me!", origin: .user, spacerWidth: 100)
}
