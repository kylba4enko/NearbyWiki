//
//  Bounds.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

struct Bounds: Decodable {
    let northeast: Coordinate
    let southwest: Coordinate

    private enum CodingKeys: String, CodingKey {
        case northeast
        case southwest
    }
}
