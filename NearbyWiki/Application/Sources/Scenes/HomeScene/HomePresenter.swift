//
//  HomePresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import Moya
import RxSwift

protocol HomePresenter {
    init(view: HomeView,
         locationService: LocationService,
         pointOfInterestRequestService: PointOfInterestRequestService)

    func viewDidLoad()
    func viewDidSelectPointOfInterest(_ identifier: Int)
}

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let locationService: LocationService
    private let pointOfInterestRequestService: PointOfInterestRequestService
    private let disposeBag = DisposeBag()
    private var currentLocation: CLLocationCoordinate2D?
    private var places: [PointOfInterest]?

    required init(view: HomeView,
                  locationService: LocationService = resolve(),
                  pointOfInterestRequestService: PointOfInterestRequestService = resolve()) {

        self.view = view
        self.locationService = locationService
        self.pointOfInterestRequestService = pointOfInterestRequestService
    }

    func viewDidLoad() {
        findInitialLocation()
    }

    func viewDidSelectPointOfInterest(_ identifier: Int) {
        guard let currentLocation = currentLocation,
            let selectedPoi = places?.first(where: { $0.identifier == identifier }) else {
            return
        }

        let poiViewController = StoryboardScene.Main.placeInfoViewController.instantiate()
        let poiPresenter = PointOfInterestPresenterImpl(view: poiViewController,
                                                          delegate: self,
                                                          pointOfInterest: selectedPoi,
                                                          currentLocation: currentLocation)
        poiViewController.presenter = poiPresenter
        view?.replaceContainerContent(with: poiViewController)
        view?.showContainer(true) { [weak self] in
            self?.view?.focusOn(selectedPoi.coordinate)
        }
    }
}

private extension HomePresenterImpl {

    func findInitialLocation() {
        locationService.startListenLocation()
            .take(1)
            .subscribe(onNext: { [weak self] location in
                self?.currentLocation = location.coordinate
                self?.fetchPointsOfInterest(location.coordinate)
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToGetLocation, message: error.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.locationService.stopListenLocation()
            }).disposed(by: disposeBag)
    }

    func fetchPointsOfInterest(_ coordinate: CLLocationCoordinate2D) {
        pointOfInterestRequestService.fetchPointOfInterests(latitude: coordinate.latitude,
                                                  longitude: coordinate.longitude,
                                                  radius: 10_000,
                                                  limit: 50)
            .subscribe(onSuccess: { [weak self] places in
                self?.places = places
                self?.view?.showPointsOfInterest(places)
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToLoadPointsOfInterest, message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

extension HomePresenterImpl: PointOfInterestPresenterDelegate {

    func pointOfInterestPresenterDidSelectRoute(_ route: Route) {
        guard let coordinates = route.legs.first?.steps.flatMap({ step in
            [step.startLocation.asCLLocationCoordinate2D(),
             step.endLocation.asCLLocationCoordinate2D()]}) else {
            return
        }
        view?.deselectPointsOfInterest()
        view?.showRouteCoordinates(coordinates)
        view?.updateBounds(route.bounds)
    }

    func pointOfInterestPresenterDidClose() {
        view?.deselectPointsOfInterest()
        view?.showContainer(false, completion: nil)
    }
}
