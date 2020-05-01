//
//  Leg.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

struct Leg: Decodable {

    let distance: String
    let duration: String
    let startAddress: String
    let endAddress: String
    let startLocation: Coordinate
    let endLocation: Coordinate
    let steps: [Step]

    private enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case startLocation = "start_location"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case endAddress = "end_address"
        case steps
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let distanceContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .distance)
        let durationContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .duration)
        distance = try distanceContainer.decode(String.self, forKey: .text)
        duration = try durationContainer.decode(String.self, forKey: .text)
        startLocation = try container.decode(Coordinate.self, forKey: .startLocation)
        endLocation = try container.decode(Coordinate.self, forKey: .endLocation)
        steps = try container.decode([Step].self, forKey: .steps)
        startAddress = try container.decode(String.self, forKey: .startAddress)
        endAddress = try container.decode(String.self, forKey: .endAddress)
    }

    init(distance: String,
         duration: String,
         startAddress: String,
         endAddress: String,
         startLocation: Coordinate,
         endLocation: Coordinate,
         steps: [Step]) {

        self.distance = distance
        self.duration = duration
        self.startAddress = startAddress
        self.endAddress = endAddress
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.steps = steps
    }
}
