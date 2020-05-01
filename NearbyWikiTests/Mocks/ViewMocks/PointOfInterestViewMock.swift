//
//  PointOfInterestViewMock.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MockSix
@testable import NearbyWiki

final class PointOfInterestViewMock: Mock, PointOfInterestView {

    enum Methods: Int {
        case showTitle
        case showImages
        case showMask
        case showRoutes
        case showAlert
    }
    typealias MockMethod = Methods

    func show(title: String) {
        registerInvocation(for: .showTitle, args: title)
    }

    func show(images: [UIImage]) {
        registerInvocation(for: .showImages, args: images)
    }

    func showMask(_ show: Bool) {
        registerInvocation(for: .showMask, args: show)
    }

    func showRoutes() {
        registerInvocation(for: .showRoutes)
    }

    func showAlert(title: String, message: String) {
        registerInvocation(for: .showAlert, args: title, message)
    }

    func showAlert(title: String, message: String, okCompletion: @escaping () -> Void) {
        registerInvocation(for: .showAlert, args: title, message, okCompletion)
    }
}
