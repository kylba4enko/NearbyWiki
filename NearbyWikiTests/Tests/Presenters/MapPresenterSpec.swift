//
//  MapPresenterSpec.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 01.05.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import Nimble
import NimbleMockSix
import Quick
import RxSwift

final class MapPresenterSpec: QuickSpec {

    //swiftlint:disable:next function_body_length
    override func spec() {

        describe("MapPresenter") {
            var presenter: MapPresenterImpl!
            var viewMock: MapViewMock!
            var pointOfInterestRequestServiceMock: PointOfInterestRequestServiceMock!
            var locationServiceMock: LocationServiceMock!

            let poiMock = PointOfInterest(identifier: 1, title: "poi", latitude: 20, longitude: 20)
            let currentLocationMock = CLLocation(latitude: 10, longitude: 10)
            let routeMock = Route.makeMockRoute()

            beforeEach {
                resetMockSix()

                viewMock = MapViewMock()
                pointOfInterestRequestServiceMock = PointOfInterestRequestServiceMock()
                locationServiceMock = LocationServiceMock()
                presenter = MapPresenterImpl(
                    view: viewMock,
                    locationService: locationServiceMock,
                    pointOfInterestRequestService: pointOfInterestRequestServiceMock
                )

                let singlePois = Single<[PointOfInterest]>.create { single in
                    single(.success([poiMock]))
                    return Disposables.create()
                }
                pointOfInterestRequestServiceMock.stub(.fetchPointsOfInterest,
                                                       andReturn: singlePois)

                let observableLocation = Observable<CLLocation>.create { observable in
                    observable.on(.next(currentLocationMock))
                    return Disposables.create()
                }
                locationServiceMock.stub(.startListenLocation,
                                         andReturn: observableLocation)
            }

            describe("on view did load") {

                beforeEach {
                    presenter.viewDidLoad()
                }

                context("when requests success") {

                    it("starts listen location") {
                        expect(locationServiceMock).to(receive(.startListenLocation))
                    }

                    it("stops listen location") {
                        expect(locationServiceMock).to(receive(.stopListenLocation))
                    }

                    it("makes points of interest request") {
                        expect(pointOfInterestRequestServiceMock)
                            .to(receive(.fetchPointsOfInterest,
                                        with: [theValue(currentLocationMock.coordinate.latitude),
                                               theValue(currentLocationMock.coordinate.longitude),
                                               theValue(10_000),
                                               theValue(50)]))
                    }

                    it("shows points of interest") {
                        expect(viewMock).to(receive(.showPointsOfInterest, with: [theValue([poiMock])]))
                    }
                }

                context("when requests failed") {

                    beforeEach {
                        let singlePois = Single<[PointOfInterest]>.create { single in
                            single(.error(NSError(domain: "test", code: 1)))
                            return Disposables.create()
                        }
                        pointOfInterestRequestServiceMock.stub(.fetchPointsOfInterest,
                                                               andReturn: singlePois)

                        let observableLocation = Observable<CLLocation>.create { observable in
                            observable.on(.error(NSError(domain: "test", code: 1)))
                            return Disposables.create()
                        }
                        locationServiceMock.stub(.startListenLocation,
                                                 andReturn: observableLocation)
                        presenter.viewDidLoad()
                    }

                    it("shows alert") {
                        expect(viewMock).to(receive(.showAlert))
                    }
                }
            }

            describe("on view did select point of interest") {

                beforeEach {
                    presenter.viewDidLoad()
                    presenter.viewDidSelectPointOfInterest(poiMock.identifier)
                }

                it("replaces container") {
                    expect(viewMock).to(receive(.replaceContainerContent))
                }

                it("clears routes") {
                    expect(viewMock).to(receive(.clearRoutes))
                }

                it("shows container") {
                    expect(viewMock).to(receive(.showContainer, with: [theValue(true)]))
                }

                it("focuses on point of interest") {
                    expect(viewMock).toEventually(receive(.focusOn, with: [theValue(poiMock.coordinate)]))
                }
            }

            describe("on view did close point of interest") {

                beforeEach {
                    presenter.viewDidLoad()
                    presenter.viewDidPressCloseButton()
                }

                it("deselects point of interest") {
                    expect(viewMock).to(receive(.deselectPointsOfInterest))
                }

                it("hides container") {
                    expect(viewMock).to(receive(.showContainer, with: [theValue(false)]))
                }
            }

            describe("on delegate did select route") {

                beforeEach {
                    presenter.viewDidLoad()
                    presenter.pointOfInterestPresenterDidSelectRoute(routeMock)
                }

                it("deselects point of interest") {
                    expect(viewMock).to(receive(.deselectPointsOfInterest))
                }

                it("shows route") {
                    let coordinates = routeMock.legs.first!.steps.flatMap({ step in
                        [step.startLocation.asCLLocationCoordinate2D(),
                         step.endLocation.asCLLocationCoordinate2D()]
                    })
                    expect(viewMock).to(receive(.showRoute, with: [theValue(coordinates)]))
                }

                it("updates bounds") {
                    expect(viewMock).to(receive(.updateBounds, with: [theValue(routeMock.bounds)]))
                }

                it("replaces container") {
                    expect(viewMock).to(receive(.replaceContainerContent))
                }
            }
        }
    }
}
