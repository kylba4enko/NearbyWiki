//
//  PointOfInterestPresenterDelegateMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MockSix
@testable import NearbyWiki

final class PointOfInterestPresenterDelegateMock: Mock, PointOfInterestPresenterDelegate {

    enum Methods: Int {
        case pointOfInterestPresenterDidSelectRoute
    }
    typealias MockMethod = Methods

    func pointOfInterestPresenterDidSelectRoute(_ route: Route) {
        registerInvocation(for: .pointOfInterestPresenterDidSelectRoute, args: route)
    }
}
