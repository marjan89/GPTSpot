//
//  String+Clipboard.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 5/6/24.
//

import Foundation
import SwiftUI

extension String {
    func copyTextToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
}
