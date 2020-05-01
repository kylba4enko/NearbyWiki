//
//  RouteRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Moya
import RxSwift

protocol RouteRequestService {
    func fetchRoute(start: Coordinate, finish: Coordinate) -> Single<[Route]>
}

final class RouteRequestServiceImpl: RouteRequestService {

    private let provider = MoyaProvider<RouteTarget>()

    func fetchRoute(start: Coordinate, finish: Coordinate) -> Single<[Route]> {
        return Single<[Route]>.create { single in
            self.provider.request(.getRoute(start, finish)) { result in
                switch result {
                case .success(let response):
                    if let dict = response.data.toDictionary(),
                        let routesList = dict["routes"] as? [Any],
                        let data = routesList.toData(),
                        let routes = try? JSONDecoder().decode([Route].self, from: data) {

                        single(.success(routes))
                    } else {
                        single(.error(MoyaError.jsonMapping(response)))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
