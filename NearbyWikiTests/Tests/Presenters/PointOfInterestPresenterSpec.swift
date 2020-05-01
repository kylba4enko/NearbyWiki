//
//  RouteStepsPresenterSpec.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki
import Nimble
import NimbleMockSix
import Quick
import RxSwift

final class PointOfInterestPresenterSpec: QuickSpec {

    //swiftlint:disable:next function_body_length
    override func spec() {

        describe("PointOfInterestPresenter") {
            var presenter: PointOfInterestPresenter!
            var viewMock: PointOfInterestViewMock!
            var delegateMock: PointOfInterestPresenterDelegateMock!
            var pointOfInterestRequestServiceMock: PointOfInterestRequestServiceMock!
            var routeRequestServiceMock: RouteRequestServiceMock!
            var imageRequestServiceMock: ImageRequestServiceMock!

            let poiMock = PointOfInterest(identifier: 1, title: "poi", latitude: 20, longitude: 20)
            let currentLocationMock = CLLocationCoordinate2D(latitude: 10, longitude: 10)
            let thumbnails = [PointOfInterestThumbnail(title: "image1"), PointOfInterestThumbnail(title: "image2")]
            let poiDetailedMock = PointOfInterestDetails(identifier: 1,
                                                         title: "poi",
                                                         url: "url",
                                                         thumbnails: thumbnails)
            let routeMock = Route.makeMockRoute()

            beforeEach {
                resetMockSix()

                viewMock = PointOfInterestViewMock()
                delegateMock = PointOfInterestPresenterDelegateMock()
                pointOfInterestRequestServiceMock = PointOfInterestRequestServiceMock()
                routeRequestServiceMock = RouteRequestServiceMock()
                imageRequestServiceMock = ImageRequestServiceMock()
                presenter = PointOfInterestPresenterImpl(
                    view: viewMock,
                    delegate: delegateMock,
                    pointOfInterest: poiMock,
                    currentLocation: currentLocationMock,
                    pointOfInterestRequestService: pointOfInterestRequestServiceMock,
                    routeRequestService: routeRequestServiceMock,
                    imageRequestService: imageRequestServiceMock
                )
            }

            describe("on view did load") {

                context("when requests success") {

                    beforeEach {
                        let singlePoi = Single<PointOfInterestDetails>.create { single in
                            single(.success(poiDetailedMock))
                            return Disposables.create()
                        }
                        pointOfInterestRequestServiceMock.stub(.fetchPointOfInterestDetails, andReturn: singlePoi)

                        let singleImage = Single<UIImage>.create { single in
                            single(.success(UIImage()))
                            return Disposables.create()
                        }
                        imageRequestServiceMock.stub(.fetchImage, andReturn: singleImage)

                        let singleRoutes = Single<[Route]>.create { single in
                            single(.success([routeMock]))
                            return Disposables.create()
                        }
                        routeRequestServiceMock.stub(.fetchRoute, andReturn: singleRoutes)

                        presenter.viewDidLoad()
                    }

                    it("shows mask") {
                        expect(viewMock).to(receive(.showMask, with: [theValue(true)]))
                    }

                    it("makes point of interest details request") {
                        expect(pointOfInterestRequestServiceMock)
                            .to(receive(.fetchPointOfInterestDetails, with: [theValue(poiMock.identifier)]))
                    }

                    it("makes route request") {
                        let start = Coordinate(lat: currentLocationMock.latitude, lon: currentLocationMock.longitude)
                        let finish = Coordinate(lat: poiMock.latitude, lon: poiMock.longitude)
                        expect(routeRequestServiceMock).to(receive(.fetchRoute, with: [theValue(start),
                                                                                       theValue(finish)]))
                    }

                    it("makes images request") {
                        expect(imageRequestServiceMock)
                            .to(receive(.fetchImage,
                                        with: [theValue(poiDetailedMock.thumbnails.first?.fileName!), theValue(100)]))
                        expect(imageRequestServiceMock)
                            .to(receive(.fetchImage,
                                        with: [theValue(poiDetailedMock.thumbnails.last?.fileName!), theValue(100)]))
                    }

                    it("shows title") {
                        expect(viewMock).to(receive(.showTitle, with: [theValue(poiDetailedMock.title)]))
                    }

                    it("shows routes") {
                        expect(viewMock).to(receive(.showRoutes))
                    }

                    it("shows images") {
                        expect(viewMock).to(receive(.showImages))
                    }

                    it("hides mask") {
                        expect(viewMock).to(receive(.showMask, with: [theValue(false)]))
                    }
                }

                context("when request failed") {

                    beforeEach {
                        let singlePoi = Single<PointOfInterestDetails>.create { single in
                            single(.error(NSError(domain: "test", code: 1)))
                            return Disposables.create()
                        }
                        pointOfInterestRequestServiceMock.stub(.fetchPointOfInterestDetails, andReturn: singlePoi)

                        presenter.viewDidLoad()
                    }

                    it("shows alert") {
                        expect(viewMock).to(receive(.showAlert))
                    }
                }
            }

            describe("on view did select rout") {

                beforeEach {
                    presenter.viewDidSelectRoute(routeMock)
                }

                it("calls delegate") {
                    expect(delegateMock).to(receive(.pointOfInterestPresenterDidSelectRoute,
                                                    with: [theValue(routeMock)]))
                }
            }
        }
    }
}
