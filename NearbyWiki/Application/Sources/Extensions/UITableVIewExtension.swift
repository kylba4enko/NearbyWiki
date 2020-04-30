//
//  UITableVIewExtension.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 29.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T>(_ cellClass: T.Type) where T: UITableViewCell & ReusableView {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register<T>(_ cellClass: T.Type) where T: UITableViewCell & ReusableView & NibLoadableView {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell & ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }

    func cellForRow<T>(at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Could not return cell of type: \(T.self)")
        }

        return cell
    }
}
