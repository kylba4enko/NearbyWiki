//
//  RouteStepTableViewCell.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class RouteStepTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var instructionLabel: UILabel!

    func showStep(_ step: Step, number: Int) {
        numberLabel.text = "\(number)."
        distanceLabel.text = step.distance
        durationLabel.text = step.duration
        instructionLabel.attributedText = step.instuction.toHtmlAttributedString()
    }
}
