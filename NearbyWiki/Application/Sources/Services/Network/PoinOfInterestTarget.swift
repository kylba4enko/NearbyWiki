//
//  PoinOfInterestTarget.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Moya

enum PointOfInterestTarget {
    case getPointOfInterestList(Double, Double, Int, Int)
    case getPointOfInterestDetails(Int)
}

extension PointOfInterestTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.wikipediaApiUrl)!
    }

    var path: String {
        .empty
    }

    var method: Method {
        switch self {
        case .getPointOfInterestList, .getPointOfInterestDetails:
            return .get
        }
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        let parameters: [String: Any]
        let commonParameters: [String: Any] = ["action": "query",
                                               "format": "json"]
        switch self {
        case .getPointOfInterestList(let lat, let lon, let radius, let limit):
            parameters = ["list": "geosearch",
                          "gsradius": radius,
                          "gscoord": "\(lat)|\(lon)",
                          "gslimit": limit]
        case .getPointOfInterestDetails(let pageId):
            parameters = ["pageids": pageId,
                          "prop": "info|description|images",
                          "inprop": "url"
            ]
        }
        return .requestParameters(parameters: commonParameters.adding(parameters), encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
