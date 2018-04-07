//
//  BlurredUIView.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

final class BlurredUIView: UIView {
    
    @IBInspectable var blurBackground: Bool = false {
        didSet {
            removeBlurEffectIfNeeded()
            if blurBackground {
                addBlurEffect()
            }
        }
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        clipsToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    private func removeBlurEffectIfNeeded() {
        let blurredEffectViews = subviews.filter { $0 is UIVisualEffectView }
        blurredEffectViews.forEach { $0.removeFromSuperview() }
    }
}
