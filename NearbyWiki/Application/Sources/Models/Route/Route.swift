//
//  Route.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

struct Route: Decodable {
    let legs: [Leg]
    let bounds: Bounds

    private enum CodingKeys: String, CodingKey {
        case legs
        case bounds
    }
}
