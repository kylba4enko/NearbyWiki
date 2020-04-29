//
//  PlaceInfoView.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol PointOfInterestView: class, AlertViewable {
    func show(title: String)
}

class PointOfInterestViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    var presenter: PointOfInterestPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @IBAction private func closeButtonPressed() {
        presenter.viewDidPressCloseButton()
    }
}

extension PointOfInterestViewController: PointOfInterestView {

    func show(title: String) {
        titleLabel.text = title
    }
}
