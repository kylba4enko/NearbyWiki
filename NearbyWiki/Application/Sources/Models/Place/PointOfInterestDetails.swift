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
    let url: String
    let thumbnails: [PointOfInterestThumbnail]

    private enum CodingKeys: String, CodingKey {
        case identifier = "pageid"
        case title
        case thumbnails = "images"
        case url = "fullurl"
    }
}

struct PointOfInterestThumbnail: Decodable {

    let title: String
    var fileName: String? {
        title.components(separatedBy: ":").last
    }

    private enum CodingKeys: String, CodingKey {
        case title
    }
}
