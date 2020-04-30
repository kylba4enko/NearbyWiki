//
//  PointOfInterestRequestServiceMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import RxSwift

final class PointOfInterestRequestServiceMock: Mock, PointOfInterestRequestService {

    enum Methods: Int {
        case fetchPointsOfInterest
        case fetchPointOfInterestDetails
    }
    typealias MockMethod = Methods

    func fetchPointOfInterestDetails(_ identifier: Int) -> Single<PointOfInterestDetails> {
        let pointOfInterestMock = PointOfInterestDetails(identifier: 1, title: "test", url: "url", thumbnails: [])
        let single = Single<PointOfInterestDetails>.create { single in
            single(.success(pointOfInterestMock))
            return Disposables.create()
        }

        return registerInvocation(for: .fetchPointOfInterestDetails,
                                  args: identifier,
                                  andReturn: single)
    }

    func fetchPointOfInterests(latitude: Double,
                               longitude: Double,
                               radius: Int,
                               limit: Int) -> Single<[PointOfInterest]> {

        let single = Single<[PointOfInterest]>.create { single in
            single(.success([]))
            return Disposables.create()
        }

        return registerInvocation(for: .fetchPointsOfInterest,
                                  args: latitude, longitude, radius, limit,
                                  andReturn: single)
    }
}
