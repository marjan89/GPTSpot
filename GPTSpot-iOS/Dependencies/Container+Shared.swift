//
//  Container+Shared.swift
//  GPTSpot-iOS
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation
import GPTSpot_Common

extension Container {

    public static let shared = Container.container(for: DataModule.self, CommonModule.self, ServiceModule.self)
}
