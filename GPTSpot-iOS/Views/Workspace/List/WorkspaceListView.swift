//
//  WorkspaceListView.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/4/24.
//

import SwiftUI

struct WorkspaceListView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { index in
                    NavigationLink {

                    } label: {
                        WorkspaceItemView(workspaceIndex: index)
                    }
                }
            }
            .navigationTitle("Workspace")
        }
    }
}

#Preview {
    WorkspaceListView()
}
