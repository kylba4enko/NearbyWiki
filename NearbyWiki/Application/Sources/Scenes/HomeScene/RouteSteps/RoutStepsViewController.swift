//
//  RoutStepsViewController.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol RouteStepsView: class {
    func reloadSteps()
}

class RouteStepsViewController: UIViewController, RouteStepsView {

    @IBOutlet private weak var stepsTableView: UITableView!

    var presenter: RouteStepsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    func reloadSteps() {
        stepsTableView.reloadData()
    }
}

extension RouteStepsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.stepsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RouteStepTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let step = presenter.step(for: indexPath.row)
        cell.showStep(step, number: indexPath.row + 1)

        return cell
    }
}
