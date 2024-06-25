//
//  Module.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 28/6/24.
//

import Foundation

public protocol Module {

    init(with container: Container) throws

    var dependencies: [ObjectIdentifier: Any] { get set }
}
