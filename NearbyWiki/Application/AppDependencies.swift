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

    $0.register(PointOfInterestRequestService.self) { _ in
        PointOfInterestRequestServiceImpl()
    }.inObjectScope(.transient)

    $0.register(ImageRequestService.self) { _ in
        ImageRequestServiceImpl()
    }.inObjectScope(.transient)

    $0.register(RouteRequestService.self) { _ in
        RouteRequestServiceImpl()
    }.inObjectScope(.transient)
}

func resolve() -> LocationService { return resolve(LocationService.self) }
func resolve() -> PointOfInterestRequestService { return resolve(PointOfInterestRequestService.self) }
func resolve() -> ImageRequestService { return resolve(ImageRequestService.self) }
func resolve() -> RouteRequestService { return resolve(RouteRequestService.self) }

private func resolve<T>(_ type: T.Type) -> T {
    guard let resolved = container.resolve(type) else {
        fatalError("Couldn't resolve dependency of type \(type)")
    }
    return resolved
}
