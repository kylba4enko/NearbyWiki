//
//  DictionaryExtension.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation

extension Dictionary {

    func adding(_ dictionary: [Key: Value]) -> [Key: Value] {
        var result = self
        dictionary.forEach { result[$0] = $1 }
        return result
    }
}
