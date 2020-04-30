//
//  PointOfInterestPresenter.swift
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

        describe("RouteStepsPresenter") {
            var presenter: RouteStepsPresenterImpl!
            var viewMock: RouteStepsViewMock!

            beforeEach {
                resetMockSix()

                let steps = [Step(distance: "distance",
                                  duration: "duration",
                                  instruction: "instruction",
                                  startLocation: Coordinate(lat: 10, lon: 20),
                                  endLocation: Coordinate(lat: 10, lon: 20))]

                viewMock = RouteStepsViewMock()
                presenter = RouteStepsPresenterImpl(view: viewMock, steps: steps)
            }

            describe("on view did load") {

                beforeEach {
                    presenter.viewDidLoad()
                }

                it("shows steps") {
                    expect(viewMock).to(receive(.showSteps))
                }
            }
        }
    }
}
