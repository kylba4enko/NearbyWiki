//
//  AppDependencies.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Swinject

var container: Container = .init {

    $0.register(LocationService.self) { _ in
        LocationServiceImpl()
    }.inObjectScope(.transient)
}

func resolve() -> LocationService { return resolve(LocationService.self) }

private func resolve<T>(_ type: T.Type) -> T {
    guard let resolved = container.resolve(type) else {
        fatalError("Couldn't resolve dependency of type \(type)")
    }
    return resolved
}
