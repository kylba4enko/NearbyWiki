//
//  PlaceInfo.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation

struct PointOfInterest: Decodable {

    let identifier: Int
    let title: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "pageid"
        case title
        case latitude = "lat"
        case longitude = "lon"
    }
}
