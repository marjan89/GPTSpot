//
//  Container+Shaared.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import GPTSpot_Common

extension Container {

    public static var shared: Container = .container(for: DataModule.self, CommonModule.self)
}
