//
//  LocationServiceMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import RxSwift

final class LocationServiceMock: Mock, LocationService {

    enum Methods: Int {
        case startListenLocation
        case stopListenLocation
    }
    typealias MockMethod = Methods

    func startListenLocation() -> Observable<CLLocation> {
        registerInvocation(for: .startListenLocation, andReturn: Observable.empty())
    }

    func stopListenLocation() {
        registerInvocation(for: .stopListenLocation)
    }
}
