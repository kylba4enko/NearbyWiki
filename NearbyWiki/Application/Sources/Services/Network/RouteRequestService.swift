//
//  RouteRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Alamofire
import Moya
import RxSwift

protocol RouteRequestService {
    func fetchRoute(start: Coordinate, finish: Coordinate) -> Single<[Route]>
}

class RouteRequestServiceImpl: RouteRequestService {

    private let provider = MoyaProvider<RouteTarget>(plugins: [NetworkLoggerPlugin()])

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

private enum RouteTarget {
    case getRoute(Coordinate, Coordinate)
}

extension RouteTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.googleApiUrl)!
    }

    var path: String {
        "directions/json"
    }

    var method: HTTPMethod {
        .get
    }

    var sampleData: Data {
        Data()
    }
    var task: Task {
        let parameters: [String: Any]
        switch self {
        case .getRoute(let start, let finish):
            parameters = [
                "origin": "\(start.lat),\(start.lon)",
                "destination": "\(finish.lat),\(finish.lon)",
                "key": PlistFiles.googleApiKey]
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
