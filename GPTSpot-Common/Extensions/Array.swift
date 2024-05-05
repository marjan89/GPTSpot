//
//  Array.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 5/5/24.
//

import Foundation

public extension Array where Element: Hashable {

    func distinct() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}
