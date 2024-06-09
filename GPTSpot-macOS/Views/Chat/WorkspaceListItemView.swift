//
//  WorkspaceListItemView.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 9/6/24.
//

import SwiftUI
import GPTSpot_Common
import SwiftData

struct WorkspaceListItemView: View {

    private let content: String
    private let workspaceIndex: Int
    private let selected: Bool
    let onWorkspaceSelected: (_ workspace: Int) -> Void

    init(workspaceIndex: Int, selected: Bool, content: String, onWorkspaceSelected: @escaping (Int) -> Void) {
        self.workspaceIndex = workspaceIndex
        self.content = content
        self.onWorkspaceSelected = onWorkspaceSelected
        self.selected = selected
    }

    var body: some View {
        Button {
            onWorkspaceSelected(workspaceIndex)
        } label: {
            HStack {
                ZStack {
                    Color(.blue)
                        .frame(width: 40, height: 40)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .imageScale(.medium)
                    Text("⌘\(workspaceIndex)")
                        .fontWeight(.bold)
                        .font(.headline)
                }
                VStack {
                    Text("Workspace ⌘\(workspaceIndex)")
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .font(.headline)
                    Text(content)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
            .padding(.all, 8)
            .background(selected ? Color(Color.accentColor) : .clear)
            .roundedCorners(radius: 8)
            .frame(height: 64)
        }
        .foregroundStyle(.foreground)
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    WorkspaceListItemView(
        workspaceIndex: 2,
        selected: true,
        content: "Hello!",
        onWorkspaceSelected: { _ in
        }
    )
}
