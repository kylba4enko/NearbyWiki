//
//  Extensions.swift
//  NearbyWikiTests
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

@testable import NearbyWiki

extension Route: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.bounds == rhs.bounds
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
