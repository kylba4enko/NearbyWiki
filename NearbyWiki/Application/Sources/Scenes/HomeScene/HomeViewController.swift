//
//  ViewController.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import MapKit
import UIKit

protocol HomeView: class, AlertViewable {
    func showCurrentCoordinate(_ coordinate: CLLocationCoordinate2D)
    func showNearbyPlaces(_ places: [PlaceInfo])
}

class HomeViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!

    var presenter: HomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension HomeViewController: HomeView {

    func showCurrentCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = L10n.you
        mapView.addAnnotation(annotation)

        presenter.viewDidShowInitialLocation()
    }

    func showNearbyPlaces(_ places: [PlaceInfo]) {
        let annotations: [MKPointAnnotation] = places.map { place in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            annotation.title = place.title
            return annotation
        }

        mapView.addAnnotations(annotations)
    }
}
