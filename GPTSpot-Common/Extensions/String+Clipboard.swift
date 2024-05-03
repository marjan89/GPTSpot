//
//  String+Clipboard.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/31/24.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit

extension String {
    func copyTextToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
        
    }
}

#endif

#if canImport(UIKit)
import UIKit

extension String {
    
    func copyTextToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
}
#endif

