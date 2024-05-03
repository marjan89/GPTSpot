//
//  String+Clipboard.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 5/3/24.
//

import Foundation
import SwiftUI
import AppKit

extension String {
    func copyTextToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
        
    }
}
