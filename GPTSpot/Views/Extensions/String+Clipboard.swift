//
//  String+Clipboard.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/31/24.
//

import Foundation
import SwiftUI

extension String {
    
    func copyTextToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
}
