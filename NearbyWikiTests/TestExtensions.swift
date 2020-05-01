//
//  Extensions.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
@testable import NearbyWiki

extension Route: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.bounds == rhs.bounds
    }

    static func makeMockRoute() -> Route {
        let coordiante = Coordinate(lat: 10, lon: 20)

        let step = Step(distance: "dist1",
                        duration: "dur1",
                        instruction: "inst1",
                        startLocation: coordiante,
                        endLocation: coordiante)

        let leg = Leg(distance: "dist",
                      duration: "dur",
                      startAddress: "sa",
                      endAddress: "ea",
                      startLocation: coordiante,
                      endLocation: coordiante,
                      steps: [step, step, step])

        return Route(legs: [leg], bounds: Bounds(northeast: coordiante, southwest: coordiante))
    }
}

extension Bounds: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.northeast == rhs.northeast && lhs.southwest == rhs.southwest
    }
}

extension Coordinate: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
}

extension PointOfInterest: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension CLLocationCoordinate2D: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
