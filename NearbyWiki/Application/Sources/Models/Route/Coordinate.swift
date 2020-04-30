//
//  Coordinate.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation

struct Coordinate: Decodable {

    let lat: Double
    let lon: Double

    func asCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lng"
    }
}
