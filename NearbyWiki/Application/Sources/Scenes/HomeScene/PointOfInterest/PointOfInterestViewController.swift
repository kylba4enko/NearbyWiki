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
    func show(images: [UIImage])
    func reloadRoutes()
}

class PointOfInterestViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var routesTableView: UITableView!

    var presenter: PointOfInterestPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @IBAction private  func wikipediaButtonPressed() {
        presenter.viewDidPressWikipediaButton()
    }
}

extension PointOfInterestViewController: PointOfInterestView {

    func show(title: String) {
        titleLabel.text = title
    }

    func show(images: [UIImage]) {
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
    }

    func reloadRoutes() {
        routesTableView.reloadData()
    }
}

extension PointOfInterestViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.routesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LegTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let route = presenter.route(for: indexPath.row)
        if let leg = route.legs.first {
            cell.onGetThereButtonPressedCallback = { [weak self] in
                self?.presenter.viewDidSelectRoute(route)
            }
            cell.showLeg(leg, number: indexPath.row + 1)
        }
        return cell
    }
}
