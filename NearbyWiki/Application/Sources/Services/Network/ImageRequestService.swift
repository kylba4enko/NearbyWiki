//
//  ImageRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Moya
import RxSwift

protocol ImageRequestService {
    func fetchImage(name: String, size: Int) -> Single<Image>
}

final class ImageRequestServiceImpl: ImageRequestService {

    private let provider = MoyaProvider<ImageTarget>()

    func fetchImage(name: String, size: Int) -> Single<Image> {
        provider.rx.request(.getImage(name, size)).mapImage()
    }
}
