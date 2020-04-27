//
//  AlertView.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol AlertViewable {
    func showAlert(title: String, message: String, okCompletion: (() -> Void)?)
}

extension AlertViewable where Self: UIViewController {

    func showAlert(title: String, message: String, okCompletion: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: L10n.ok, style: .default, handler: { _ in
            okCompletion?()
        })
        showAlert(title: title, message: message, with: [okAction])
    }

    private func showAlert(title: String, message: String, with alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertActions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }
}
