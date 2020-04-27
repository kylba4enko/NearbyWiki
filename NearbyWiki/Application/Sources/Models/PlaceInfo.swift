//
//  PlaceInfo.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Mapper

struct PlaceInfo: Mappable {

    let identifier: Int
    let title: String
    let latitude: Double
    let longitude: Double

    init(map: Mapper) throws {
        identifier = try map.from("pageid")
        title = try map.from("title")
        latitude = try map.from("lat")
        longitude = try map.from("lon")
    }
}

struct PlacesResponse: Mappable {

    let places: [PlaceInfo]

    init(map: Mapper) throws {
        places = try map.from("geosearch")
    }
}
