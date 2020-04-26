//
//  AppDelegate.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let rootNavigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: rootNavigationController)
        appCoordinator.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}
