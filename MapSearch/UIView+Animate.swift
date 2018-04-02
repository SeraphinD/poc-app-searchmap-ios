//
//  UIView+Animate.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 02/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateFromBottom(delay: Double = 0) {
        alpha = 0.6
        transform = transform.translatedBy(x: 0.0, y: 150.0)
        UIView.animate(withDuration: 0.2, delay: delay, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func hideFromTop() {
        alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = self.transform.translatedBy(x: 0.0, y: 150.0)
        })
    }
}
