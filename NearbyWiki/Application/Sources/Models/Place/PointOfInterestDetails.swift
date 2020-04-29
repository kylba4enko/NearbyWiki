//
//  PlaceDetailedInfo.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

struct PointOfInterestDetails: Decodable {

    let identifier: Int
    let title: String
    let thumbnails: [PlaceThumbnail]

    private enum CodingKeys: String, CodingKey {
        case identifier = "pageid"
        case title
        case thumbnails = "images"
    }
}

struct PlaceThumbnail: Decodable {

    let title: String

    private enum CodingKeys: String, CodingKey {
        case title
    }
}
