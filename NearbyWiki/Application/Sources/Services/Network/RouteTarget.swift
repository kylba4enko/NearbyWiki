//
//  RouteTarget.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Moya

enum RouteTarget {
    case getRoute(Coordinate, Coordinate)
}

extension RouteTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.googleApiUrl)!
    }

    var path: String {
        "directions/json"
    }

    var method: Method {
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
