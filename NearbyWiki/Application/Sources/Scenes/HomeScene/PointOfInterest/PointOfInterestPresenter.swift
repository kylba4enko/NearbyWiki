//
//  PlaceInfoPresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MapKit
import Moya
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

class PointOfInterestPresenterImpl: PointOfInterestPresenter {

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
        fetchPointOfInterestDetails()
        fetchRoutes()
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

    func fetchPointOfInterestDetails() {
        pointOfInterestRequestService.fetchPointOfInterestDetails(pointOfInterest.identifier)
                .subscribe(onSuccess: { [weak self] poi in
                    guard let self = self else {
                        return
                    }
                    self.pointOfInterestDetailed = poi
                    self.fetchImages()
                    self.view?.show(title: poi.title)

                }, onError: { [weak self] error in
                    self?.view?.showAlert(title: L10n.failedToLoadPointsOfInterest, message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }

    func fetchRoutes() {
        let start = Coordinate(lat: currentLocation.latitude, lon: currentLocation.longitude)
        let finish = Coordinate(lat: pointOfInterest.latitude, lon: pointOfInterest.longitude)
        routeRequestService.fetchRoute(start: start, finish: finish)
            .subscribe(onSuccess: { [weak self] routes in
                self?.routes = routes
                self?.view?.reloadRoutes()
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToLoadRoutes, message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    func fetchImages() {
        guard let poi = pointOfInterestDetailed else {
            return
        }

        let collection: [Single<Image>] = poi.thumbnails.prefix(3).compactMap { $0.fileName }.map {
            self.imageRequestService.fetchImage(name: $0, size: 100)
        }
        Single.zip(collection).subscribe(onSuccess: { images in
            self.view?.show(images: images)
        }).disposed(by: self.disposeBag)
    }
}
