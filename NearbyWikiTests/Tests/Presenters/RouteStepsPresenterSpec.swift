//
//  RouteStepsPresenterSpec.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MockSix
@testable import NearbyWiki
import Nimble
import NimbleMockSix
import Quick

final class RouteStepsPresenterSpec: QuickSpec {

//swiftlint:disable:next function_body_length
    override func spec() {

        describe("CashOutPresenter") {
            var presenter: CashOutPresenter!
            var viewMock: CashOutViewMock!
            var delegateMock: CashOutDelegateMock!
            var validationServcieMock: ValidationServiceMock!
            var cashOutServiceMock: CashOutRequestServiceMock!
            var errorTrackingServiсeMock: ErrorTrackingServiceMock!

            let profileMock = Profile(
                id: 1,
                username: "test_username",
                rank: 1,
                money: 333,
                coins: 222,
                score: 10,
                imageUrl: "image.png",
                inviteCode: "test_code"
            )

            beforeEach {
                resetMockSix()

                viewMock = CashOutViewMock()
                delegateMock = CashOutDelegateMock()
                validationServcieMock = ValidationServiceMock()
                cashOutServiceMock = CashOutRequestServiceMock(client: resolve())
                errorTrackingServiсeMock = ErrorTrackingServiceMock()

                presenter = CashOutPresenterImpl(
                    view: viewMock,
                    profile: profileMock,
                    coordinator: delegateMock,
                    validationService: validationServcieMock,
                    cashOutService: cashOutServiceMock,
                    tracker: errorTrackingServiсeMock
                )
            }
        }
    }
}
