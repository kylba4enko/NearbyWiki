//
//  PointAnnotation.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import MapKit

final class PointAnnotation: MKPointAnnotation {

    private(set) var identifier: Int

    init(identifier: Int, title: String, coordinate: CLLocationCoordinate2D) {
        self.identifier = identifier
        super.init()
        self.title = title
        self.coordinate = coordinate
    }
}
