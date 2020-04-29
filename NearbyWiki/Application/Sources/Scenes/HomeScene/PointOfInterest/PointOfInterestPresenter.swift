//
//  PlaceInfoPresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MapKit
import RxSwift

protocol PointOfInterestPresenterDelegate: class {
    func pointOfInterestPresenterDidClose()
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
    func viewDidPressCloseButton()
}

class PointOfInterestPresenterImpl: PointOfInterestPresenter {

    private weak var view: PointOfInterestView?
    private weak var delegate: PointOfInterestPresenterDelegate?
    private let pointOfInterestRequestService: PointOfInterestRequestService
    private let routeRequestService: RouteRequestService
    private let imageRequestService: ImageRequestService
    private let currentLocation: CLLocationCoordinate2D
    private let pointOfInterest: PointOfInterest
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

    func viewDidPressCloseButton() {
        delegate?.pointOfInterestPresenterDidClose()
    }
}

private extension PointOfInterestPresenterImpl {

    func fetchPointOfInterestDetails() {
            pointOfInterestRequestService.fetchPointOfInterestDetails(pointOfInterest.identifier)
                .subscribe(onSuccess: { [weak self] placeDetails in
                    self?.view?.show(title: placeDetails.title)

    //                var coll: [Single<Response>] = []
    //                place.thumbnails.prefix(3).forEach { element in
    //                    coll.append((self?.imageRequestService.fetchImage(name: element.title))!)
    //                }
    //
    //                Single.zip(coll).subscribe(onSuccess: { elements in
    //                    self?.view?.showNearbyPlaceDetails(place)
    //                    print(elements)
    //                }) { error in
    //                    print(error)
    //                }
                }, onError: { [weak self] error in
                    self?.view?.showAlert(title: L10n.failedToGetLocation, message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }

    func fetchRoutes() {
        let start = Coordinate(lat: currentLocation.latitude, lon: currentLocation.longitude)
        let finish = Coordinate(lat: pointOfInterest.latitude, lon: pointOfInterest.longitude)
        routeRequestService.fetchRoute(start: start, finish: finish)
            .subscribe(onSuccess: { [weak self] routes in
                if let route = routes.first {
                    self?.delegate?.pointOfInterestPresenterDidSelectRoute(route)
                }
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToLoadRoutes, message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
