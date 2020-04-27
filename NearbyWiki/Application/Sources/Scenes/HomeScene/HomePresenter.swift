//
//  HomePresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

protocol HomePresenter {
    init(view: HomeView, locationService: LocationService)
    func viewDidLoad()
}

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let locationService: LocationService

    required init(view: HomeView, locationService: LocationService = resolve()) {
        self.view = view
        self.locationService = locationService
    }

    func viewDidLoad() {
        locationService.startListenLocation(onUpdate: { _ in

        }, onFail: { _ in

        })
    }
}
