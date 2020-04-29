//
//  ContainerViewable.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol ContainerViewable {
    var containerView: UIView! { get }
    func addContainerContent(viewController: UIViewController)
    func replaceContainerContent(with viewController: UIViewController)
}

extension ContainerViewable where Self: UIViewController {

    func replaceContainerContent(with viewController: UIViewController) {
        if let currentViewController = children.first {
            removeContainerContent(currentViewController)
        }
        addContainerContent(viewController: viewController)
    }

    func addContainerContent(viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    private func removeContainerContent(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
