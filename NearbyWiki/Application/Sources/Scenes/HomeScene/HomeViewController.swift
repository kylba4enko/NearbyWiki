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
    func showRouteCoordinates(_ coordinates: [CLLocationCoordinate2D])
    func updateBounds(_ bounds: Bounds)
    func deselectPointsOfInterest()
}

class HomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerViewBottomConstraint: NSLayoutConstraint!

    var presenter: HomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
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
        mapView.showAnnotations(annotations, animated: true)
    }

    func showContainer(_ show: Bool, completion: (() -> Void)?) {
        containerViewBottomConstraint.constant = show ? .zero : containerViewHeightConstraint.constant
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }

    func showRouteCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        let polilyne = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(polilyne)
    }

    func updateBounds(_ bounds: Bounds) {
        let southwest = MKMapPoint(bounds.southwest.asCLLocationCoordinate2D())
        let northeast = MKMapPoint(bounds.northeast.asCLLocationCoordinate2D())
        let rect = MKMapRect(x: fmin(southwest.x, northeast.x),
                             y: fmin(southwest.y, northeast.y),
                             width: fabs(southwest.x - northeast.x),
                             height: fabs(southwest.y - northeast.y))
        let space: CGFloat = 50
        let edgeInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        mapView.setVisibleMapRect(rect, edgePadding: edgeInset, animated: true)
    }

    func deselectPointsOfInterest() {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
}

extension HomeViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? PointAnnotation {
            presenter.viewDidSelectPointOfInterest(annotation.identifier)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 5

        return polylineRenderer
    }
}
