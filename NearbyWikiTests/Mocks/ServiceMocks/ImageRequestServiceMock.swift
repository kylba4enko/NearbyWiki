//
//  ImageRequestServiceMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import RxSwift

final class ImageRequestServiceMock: Mock, ImageRequestService {

    enum Methods: Int {
        case fetchImage
    }
    typealias MockMethod = Methods

    func fetchImage(name: String, size: Int) -> Single<UIImage> {
        let single = Single<UIImage>.create { single in
            single(.success(UIImage()))
            return Disposables.create()
        }

        return registerInvocation(for: .fetchImage,
                                  args: name, size,
                                  andReturn: single)
    }
}
