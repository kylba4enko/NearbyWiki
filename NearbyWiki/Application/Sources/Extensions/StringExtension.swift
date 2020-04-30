//
//  StringExtension.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 26.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation

extension String {
    static let empty = ""

    func toHtmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]

        return try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
    }
}
