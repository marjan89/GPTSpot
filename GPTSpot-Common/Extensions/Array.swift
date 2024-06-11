//
//  Array.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 5/5/24.
//

import Foundation

public extension Array where Element: Hashable {

    var distinct: [Element] {
        Array(Set(self))
    }
}
