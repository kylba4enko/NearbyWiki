//
//  ViewController.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MapKit
import UIKit

protocol HomeView: class, AlertViewable, ContainerViewable {
    func focusOn(_ coordinate: CLLocationCoordinate2D)
    func showPointsOfInterest(_ pointsOfInterest: [PointOfInterest])
    func showContainer(_ show: Bool, completion: (() -> Void)?)
}

class HomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerViewBottomConstraint: NSLayoutConstraint!

    var presenter: HomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        containerViewHeightConstraint.constant = view.frame.size.height / 2
        containerViewBottomConstraint.constant = containerViewHeightConstraint.constant
        presenter.viewDidLoad()
    }
}

extension HomeViewController: HomeView {

    func focusOn(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func showPointsOfInterest(_ pointsOfInterest: [PointOfInterest]) {
        let annotations = pointsOfInterest.map { poi in
            PointAnnotation(identifier: poi.identifier, title: poi.title, coordinate: poi.coordinate)
        }
        mapView.addAnnotations(annotations)
    }

    func showContainer(_ show: Bool, completion: (() -> Void)?) {
        containerViewBottomConstraint.constant = show ? .zero : containerViewHeightConstraint.constant
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
}

extension HomeViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? PointAnnotation {
            presenter.viewDidSelectPointOfInterest(annotation.identifier)
        }
    }
}
