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
    func viewDidShowInitialLocation()
}

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let locationService: LocationService
    private let placesRequestService: PlacesRequestService
    private var initialLocation: CLLocationCoordinate2D?

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

    func viewDidShowInitialLocation() {
        fetchNearbyPlaces()
    }
}

private extension HomePresenterImpl {

    func findInitialLocation() {
        locationService.startListenLocation(onUpdate: { [weak self] location in
            guard let self = self else {
                return
            }
            self.locationService.stopListenLocation()
            self.initialLocation = location.coordinate
            self.view?.showCurrentCoordinate(location.coordinate)
        }, onFail: { error in
            self.view?.showAlert(title: L10n.failedToGetLocation, message: error.localizedDescription)
        })
    }

    func fetchNearbyPlaces() {
        guard let initialLocation = initialLocation else {
            return
        }
        placesRequestService.fetchPlaces(latitude: initialLocation.latitude,
                                         longitude: initialLocation.longitude,
                                         radius: 10_000,
            limit: 50)
            .subscribe { [weak self] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .success(let response):
                    self.view?.showNearbyPlaces(response.places)
                case .error(let error):
                    self.view?.showAlert(title: L10n.failedToGetLocation,
                                         message: error.localizedDescription)
                }
            }
    }
}
