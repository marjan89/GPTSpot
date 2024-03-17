//
//  Environment+Values.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 2/27/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var library:  {
        get { self[LibraryKey.self] }
        set { self[LibraryKey.self] = newValue }
    }
}
