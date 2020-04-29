//
//  ImageRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Alamofire
import Moya
import RxSwift

protocol ImageRequestService {
    func fetchImage(name: String) -> Single<Response>
}

class ImageRequestServiceImpl: ImageRequestService {

    private let provider = MoyaProvider<ImageTarget>(plugins: [NetworkLoggerPlugin()])

    func fetchImage(name: String) -> Single<Response> {
        return provider.rx.request(.getImage(name))
    }
}

private enum ImageTarget {
    case getImage(String)
}

extension ImageTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.wikiApiUrl)!
    }

    var path: String {
        .empty
    }

    var method: HTTPMethod {
        .get
    }

    var sampleData: Data {
        Data()
    }
    var task: Task {
        let parameters: [String: Any]
        let commonParameters: [String: Any] = ["action": "query",
                                               "format": "json"]
        switch self {
        case .getImage(let name):
            parameters = ["titles": name,
                          "prop": "pageimages",
                          "pithumbsize": 100]
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
