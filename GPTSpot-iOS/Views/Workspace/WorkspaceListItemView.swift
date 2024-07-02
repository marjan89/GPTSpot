//
//  WorkspaceItemView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct WorkspaceListItemView: View {

    private let content: String
    private let workspaceIndex: Int

    init(workspaceIndex: Int, content: String) {
        self.workspaceIndex = workspaceIndex
        self.content = content
    }

    var body: some View {
        HStack {
            ZStack {
                Color(.blue)
                    .frame(width: 50, height: 50)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .imageScale(.medium)
                Text("⌘\(workspaceIndex)")
                    .fontWeight(.bold)
                    .font(.headline)
            }
            Text(content)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    WorkspaceListItemView(
        workspaceIndex: 2,
        content: "Hello!"
    )
}
