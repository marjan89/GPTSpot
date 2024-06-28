//
//  DIContainer.swift
//  GPTSpot-Common
//
//  Created by Sinisa Marjanovic on 13/6/24.
//

import Foundation
import SwiftUI
import SwiftData

public struct Container {

    private var dependencies = [ObjectIdentifier: Any]()

    public static func container(for types: Module.Type...) -> Container {
        var container: Container = Container()
        do {
            try types.forEach { type in
                container
                    .dependencies
                    .merge(try type.init(with: container).dependencies) { current, _ in current }
                print("registered module \(type)")
            }
        } catch {
            print(error)
        }
        print("container created")
        return container
    }
    public mutating func register<T>(_ dependency: T, for type: T.Type) {
        let key = ObjectIdentifier(type)
        dependencies[key] = dependency
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Dependecy \(key) not registered")
        }
        return dependency
    }
}
