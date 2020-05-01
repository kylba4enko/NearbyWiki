//
//  RouteStepViewMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MockSix
@testable import NearbyWiki

final class RouteStepsViewMock: Mock, RouteStepsView {

    enum Methods: Int {
        case showSteps
    }
    typealias MockMethod = Methods

    func showSteps() {
        registerInvocation(for: .showSteps)
    }
}
