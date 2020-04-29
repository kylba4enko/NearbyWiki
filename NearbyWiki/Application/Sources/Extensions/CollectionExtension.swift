//
//  CollectionExtension.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation

extension Collection {

    func toData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
