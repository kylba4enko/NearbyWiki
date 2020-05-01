//
//  MapViewMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 01.05.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import MockSix
@testable import NearbyWiki

final class MapViewMock: Mock, MapView {

    var containerView: UIView!

    enum Methods: Int {
        case focusOn
        case showPointsOfInterest
        case showContainer
        case showRoute
        case clearRoutes
        case updateBounds
        case deselectPointsOfInterest
        case showAlert
        case replaceContainerContent
    }
    typealias MockMethod = Methods

    func focusOn(_ coordinate: CLLocationCoordinate2D) {
        registerInvocation(for: .focusOn, args: coordinate)
    }

    func showPointsOfInterest(_ pointsOfInterest: [PointOfInterest]) {
        registerInvocation(for: .showPointsOfInterest, args: pointsOfInterest)
    }

    func showContainer(_ show: Bool, completion: (() -> Void)?) {
        completion?()
        registerInvocation(for: .showContainer, args: show)
    }

    func showRoute(_ coordinates: [CLLocationCoordinate2D]) {
        registerInvocation(for: .showRoute, args: coordinates)
    }

    func clearRoutes() {
        registerInvocation(for: .clearRoutes)
    }

    func updateBounds(_ bounds: Bounds) {
        registerInvocation(for: .updateBounds, args: bounds)
    }

    func deselectPointsOfInterest() {
        registerInvocation(for: .deselectPointsOfInterest)
    }

    func showAlert(title: String, message: String) {
        registerInvocation(for: .showAlert, args: title, message)
    }

    func showAlert(title: String, message: String, okCompletion: @escaping () -> Void) {
        registerInvocation(for: .showAlert, args: title, message)
    }

    func replaceContainerContent(with viewController: UIViewController) {
        registerInvocation(for: .replaceContainerContent, args: viewController)
    }
}
