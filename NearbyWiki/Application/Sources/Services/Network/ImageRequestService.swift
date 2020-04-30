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
    func fetchImage(name: String, size: Int) -> Single<Image>
}

class ImageRequestServiceImpl: ImageRequestService {

    private let provider = MoyaProvider<ImageTarget>()

    func fetchImage(name: String, size: Int) -> Single<Image> {
        provider.rx.request(.getImage(name, size)).mapImage()
    }
}

private enum ImageTarget {
    case getImage(String, Int)
}

extension ImageTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.wikimediaApiUrl)!
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

        switch self {
        case .getImage(let name, let size):
            parameters = ["f": name,
                          "w": size]
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        nil
    }

    var validationType: ValidationType {
        .successCodes
    }
}
