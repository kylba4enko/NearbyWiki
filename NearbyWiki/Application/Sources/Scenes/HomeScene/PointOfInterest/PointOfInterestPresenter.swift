//
//  PlaceInfoPresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import RxSwift

protocol PointOfInterestPresenterDelegate: class {
    func pointOfInterestPresenterDidSelectRoute(_ route: Route)
}

protocol PointOfInterestPresenter {

    init(view: PointOfInterestView,
         delegate: PointOfInterestPresenterDelegate,
         pointOfInterest: PointOfInterest,
         currentLocation: CLLocationCoordinate2D,
         pointOfInterestRequestService: PointOfInterestRequestService,
         routeRequestService: RouteRequestService,
         imageRequestService: ImageRequestService)

    func viewDidLoad()
    func viewDidPressWikipediaButton()
    func viewDidSelectRoute(_ route: Route)
    func routesCount() -> Int
    func route(for index: Int) -> Route
}

final class PointOfInterestPresenterImpl: PointOfInterestPresenter {

    private weak var view: PointOfInterestView?
    private weak var delegate: PointOfInterestPresenterDelegate?
    private let pointOfInterestRequestService: PointOfInterestRequestService
    private let routeRequestService: RouteRequestService
    private let imageRequestService: ImageRequestService
    private let currentLocation: CLLocationCoordinate2D
    private let pointOfInterest: PointOfInterest
    private var pointOfInterestDetailed: PointOfInterestDetails?
    private var routes: [Route] = []
    private let disposeBag = DisposeBag()

    required init(view: PointOfInterestView,
                  delegate: PointOfInterestPresenterDelegate,
                  pointOfInterest: PointOfInterest,
                  currentLocation: CLLocationCoordinate2D,
                  pointOfInterestRequestService: PointOfInterestRequestService = resolve(),
                  routeRequestService: RouteRequestService = resolve(),
                  imageRequestService: ImageRequestService = resolve()) {

        self.view = view
        self.delegate = delegate
        self.pointOfInterestRequestService = pointOfInterestRequestService
        self.routeRequestService = routeRequestService
        self.imageRequestService = imageRequestService
        self.currentLocation = currentLocation
        self.pointOfInterest = pointOfInterest
    }

    func viewDidLoad() {
        view?.showMask(true)
        Single.zip(fetchPointOfInterestDetails(), fetchRoute()).subscribe(onSuccess: { [weak self] poiDetails, routes in
            guard let self = self else {
                return
            }

            self.pointOfInterestDetailed = poiDetails
            self.routes = routes

            self.view?.show(title: poiDetails.title)
            self.view?.showRoutes()

            self.fetchImages(for: poiDetails).asObservable().subscribe(onNext: { images in
                self.view?.show(images: images)
            }, onDisposed: {
                self.view?.showMask(false)
            }).disposed(by: self.disposeBag)

        }, onError: { [weak self] error in
            self?.view?.showAlert(title: L10n.failedToLoadPointsOfInterest, message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }

    func viewDidPressWikipediaButton() {
        if let poi = pointOfInterestDetailed, let url = URL(string: poi.url) {
            UIApplication.shared.open(url)
        }
    }

    func viewDidSelectRoute(_ route: Route) {
        delegate?.pointOfInterestPresenterDidSelectRoute(route)
    }

    func routesCount() -> Int {
        routes.count
    }

    func route(for index: Int) -> Route {
        routes[index]
    }
}

private extension PointOfInterestPresenterImpl {

    func fetchPointOfInterestDetails() -> Single<PointOfInterestDetails> {
        return pointOfInterestRequestService.fetchPointOfInterestDetails(pointOfInterest.identifier)
    }

    func fetchRoute() -> Single<[Route]> {
        let start = Coordinate(lat: currentLocation.latitude, lon: currentLocation.longitude)
        let finish = Coordinate(lat: pointOfInterest.latitude, lon: pointOfInterest.longitude)
        return routeRequestService.fetchRoute(start: start, finish: finish)
    }

    func fetchImages(for pointOfInterest: PointOfInterestDetails) -> Single<[UIImage]> {
        let collection: [Single<UIImage>] = pointOfInterest.thumbnails.prefix(3).compactMap { $0.fileName }.map {
            self.imageRequestService.fetchImage(name: $0, size: 100)
        }
        return Single.zip(collection)
    }
}
