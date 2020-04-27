//
//  PlacesRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Alamofire
import Mapper
import Moya
import RxSwift

protocol PlacesRequestService {
    func fetchPlaces(latitude: Double, longitude: Double, radius: Int, limit: Int) -> Single<PlacesResponse>
}

class PlacesRequestServiceImpl: PlacesRequestService {

    private let provider = MoyaProvider<PlaceTarget>()

    func fetchPlaces(latitude: Double, longitude: Double, radius: Int, limit: Int) -> Single<PlacesResponse> {

        return provider.rx
            .request(.getPlacesList(latitude, longitude, radius, limit))
            .map(to: PlacesResponse.self, keyPath: "query")
    }
}

private enum PlaceTarget {
    case getPlacesList(Double, Double, Int, Int)
    case getPlaceDetails(Int)
}

extension PlaceTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.apiUrl)!
    }

    var path: String {
        .empty
    }

    var method: HTTPMethod {
        switch self {
        case .getPlacesList, .getPlaceDetails:
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
        case .getPlacesList(let lat, let lon, let radius, let limit):
            parameters = ["list": "geosearch",
                          "gsradius": radius,
                          "gscoord": "\(lat)|\(lon)",
                          "gslimit": limit]
        case .getPlaceDetails(let pageId):
            parameters = ["pageId": pageId]
        }
        return .requestParameters(parameters: commonParameters + parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
