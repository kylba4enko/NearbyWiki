//
//  NibLoadableView.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 28.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {
    static var nib: UINib { get }
    func instantiateFromNib() -> UIView?
}

extension NibLoadableView where Self: UIView {

    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }

    func instantiateFromNib() -> UIView? {
        return Self.nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
