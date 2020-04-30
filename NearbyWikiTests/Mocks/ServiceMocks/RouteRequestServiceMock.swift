//
//  RouteRequestServiceMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import RxSwift

final class RouteRequestServiceMock: Mock, RouteRequestService {

    enum Methods: Int {
        case fetchRoute
    }
    typealias MockMethod = Methods

    func fetchRoute(start: Coordinate, finish: Coordinate) -> Single<[Route]> {
        let single = Single<[Route]>.create { single in
            single(.success([]))
            return Disposables.create()
        }

        return registerInvocation(for: .fetchRoute,
                                  args: start, finish,
                                  andReturn: single)
    }
}
