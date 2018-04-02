//
//  UIView+Animate.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 02/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

extension UIView {
    func animateFromBottom() {
        alpha = 0.6
        transform = transform.translatedBy(x: 0.0, y: 150.0)
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
}
