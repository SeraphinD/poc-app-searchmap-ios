//
//  String+Localized.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 05/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
