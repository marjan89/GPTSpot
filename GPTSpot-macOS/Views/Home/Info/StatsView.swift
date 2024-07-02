//
//  ChatViewStatsView.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/30/24.
//

import SwiftUI
import SwiftData
import GPTSpot_Common

struct StatsView: View {

    @Query var chatMessages: [ChatMessage]

    @AppStorage(UserDefaults.AIServerKeys.maxHistory) private var maxHistory = 6
    @AppStorage(UserDefaults.AIServerKeys.aiModel) private var aiModel = "Not defined"

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
    Previewer {
        StatsView(workspace: 1)
    }
}
