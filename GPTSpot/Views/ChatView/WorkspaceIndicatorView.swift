//
//  WorkspaceIndicatorView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/30/24.
//

import SwiftUI

struct WorkspaceIndicatorView: View {
    
    @Binding var workspace: Int
    
    var body: some View {
        ForEach(1...9, id: \.self) { index in
            Button("**⌘\(index)**") { workspace = index }
                .accessibilityLabel("Workspace \(index)")
                .keyboardShortcut(.init(Character(UnicodeScalarType(index))))
                .padding(4)
                .buttonStyle(BorderlessButtonStyle())
                .background( workspace == index ? .accentColor : Color.clear)
                .cornerRadius(4)
                .padding(.trailing, 4)
        }
    }
}

#Preview {
    @State var workspace: Int = 1
    return WorkspaceIndicatorView(workspace: $workspace)
}
