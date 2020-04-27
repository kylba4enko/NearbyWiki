//
//  HomePresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation

protocol HomePresenter {
    init(view: HomeView, locationService: LocationService)
    func viewDidLoad()
    func viewDidShowInitialLocation()
}

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let locationService: LocationService
    private var initialLocation: CLLocationCoordinate2D?

    required init(view: HomeView, locationService: LocationService = resolve()) {
        self.view = view
        self.locationService = locationService
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

    }
}
