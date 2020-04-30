//
//  ReusableView.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
