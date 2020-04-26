//
//  AppCoordinator.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol Coordinator {
    init(navigationController: UINavigationController)
    func start()
}

final class AppCoordinator: Coordinator {

    private let rootNavigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
        self.rootNavigationController.isNavigationBarHidden = true
    }

    func start() {

    }
}

