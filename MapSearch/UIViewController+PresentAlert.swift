//
//  UIViewController+PresentAlert.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertLocation(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: R.String.ok,
                                        style: .default) { (action) in }
        let settingsAction = UIAlertAction(title: R.String.settings,
                                           style: .cancel) { action in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alert.addAction(settingsAction)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
