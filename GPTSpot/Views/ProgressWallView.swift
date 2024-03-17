//
//  ProgressWallView.swift
//  GPTSpot
//
//  Created by Sinisa on 26.2.24..
//

import Foundation
import SwiftUI

struct PogressWallView: View {
    var body: some View {
        ZStack {
            Color(.windowBackgroundColor)
            ProgressView()
        }
    }
}

#Preview {
    PogressWallView()
}
