//
//  WorkspaceItemView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI

struct WorkspaceItemView: View {

    var workspaceIndex: Int

    var body: some View {

        ZStack {
            Color(.blue)
                .frame(width: 50, height: 50)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .imageScale(.medium)
            Text("⌘\(workspaceIndex)")
                .fontWeight(.bold)
                .font(.headline)
        }
    }
}

#Preview {
    WorkspaceItemView(workspaceIndex: 1)
}
