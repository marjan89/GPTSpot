//
//  ChatViewStatsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/30/24.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    @Query var chatMessages: [ChatMessage]

    @AppStorage(AIServerDefaultsKeys.maxHistory) private var maxHistory = 6
    @AppStorage(AIServerDefaultsKeys.aiModel) private var aiModel = "Not defined"
    
    init(workspace: Int) {
        _chatMessages = Query(
            filter: #Predicate<ChatMessage> { message in
                message.workspace == workspace
            }
        )
    }
    
    var body: some View {
        HStack {
            Text("total history: **\(chatMessages.count)**")
            Text("history max: **\(maxHistory)**")
            Text("**\(aiModel)**")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return StatsView(workspace: 1)
        .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
