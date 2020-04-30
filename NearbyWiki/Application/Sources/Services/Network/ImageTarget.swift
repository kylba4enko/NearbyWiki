//
//  ImageTarget.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Moya

enum ImageTarget {
    case getImage(String, Int)
}

extension ImageTarget: TargetType {

    var baseURL: URL {
        URL(string: PlistFiles.wikimediaApiUrl)!
    }

    var path: String {
        .empty
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
