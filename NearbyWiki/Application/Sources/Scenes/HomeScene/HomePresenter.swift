//
//  HomePresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import RxSwift

protocol HomePresenter {
    init(view: HomeView, locationService: LocationService, placesRequestService: PlacesRequestService)
    func viewDidLoad()
}

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let locationService: LocationService
    private let placesRequestService: PlacesRequestService
    private let disposeBag = DisposeBag()

    required init(view: HomeView,
                  locationService: LocationService = resolve(),
                  placesRequestService: PlacesRequestService = resolve()) {

        self.view = view
        self.locationService = locationService
        self.placesRequestService = placesRequestService
    }

    func viewDidLoad() {
        findInitialLocation()
    }
}

private extension HomePresenterImpl {

    func findInitialLocation() {
        locationService.startListenLocation()
            .take(1)
            .subscribe(onNext: { [weak self] location in
                self?.view?.showCurrentUserLocation(location.coordinate)
                self?.fetchNearbyPlaces(location.coordinate)
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToGetLocation, message: error.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.locationService.stopListenLocation()
            }).disposed(by: disposeBag)
    }

    func fetchNearbyPlaces(_ coordinate: CLLocationCoordinate2D) {
        placesRequestService.fetchPlaces(latitude: coordinate.latitude,
                                         longitude: coordinate.longitude,
                                         radius: 10_000,
                                         limit: 50)
            .subscribe(onSuccess: { [weak self] response in
                self?.view?.showNearbyPlaces(response.places)
            }, onError: { [weak self] error in
                self?.view?.showAlert(title: L10n.failedToGetLocation, message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
