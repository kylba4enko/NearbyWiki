//
//  RouteTableViewCell.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class LegTableViewCell: UITableViewCell, ReusableView {

    var onGetThereButtonPressedCallback: (() -> Void)?

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!

    func showLeg(_ leg: Leg, number: Int) {
        numberLabel.text = "\(number)."
        distanceLabel.text = leg.distance
        durationLabel.text = leg.duration
    }

    @IBAction func getThereButtonPressed() {
        onGetThereButtonPressedCallback?()
    }
}
