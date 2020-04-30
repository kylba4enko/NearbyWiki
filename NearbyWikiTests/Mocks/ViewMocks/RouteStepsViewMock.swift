//
//  RouteStepViewMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MockSix
@testable import NearbyWiki

final class RouteStepsViewMock: UIViewController, Mock, RouteStepsView {
    func reloadSteps() {

    }

    enum Methods: Int {
        case setUserNameValid
        case setPasswordValid
        case showAlert
        case showLoadingIndicator
        case hideLoadingIndicator
    }
    typealias MockMethod = Methods

}
