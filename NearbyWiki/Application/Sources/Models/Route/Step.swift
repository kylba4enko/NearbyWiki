//
//  Step.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

struct Step: Decodable {

    let distance: String
    let duration: String
    let instruction: String
    let startLocation: Coordinate
    let endLocation: Coordinate

    private enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case instuction = "html_instructions"
        case startLocation = "start_location"
        case endLocation = "end_location"
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let distanceContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .distance)
        let durationContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .duration)
        distance = try distanceContainer.decode(String.self, forKey: .text)
        duration = try durationContainer.decode(String.self, forKey: .text)
        instruction = try container.decode(String.self, forKey: .instuction)
        startLocation = try container.decode(Coordinate.self, forKey: .startLocation)
        endLocation = try container.decode(Coordinate.self, forKey: .endLocation)
    }

    init(distance: String, duration: String, instruction: String, startLocation: Coordinate, endLocation: Coordinate) {
        self.distance = distance
        self.duration = duration
        self.instruction = instruction
        self.startLocation = startLocation
        self.endLocation = endLocation
    }
}