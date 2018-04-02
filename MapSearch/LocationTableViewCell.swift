//
//  LocationTableViewCell.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 01/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var streetLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!

    var location: Location! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        nameLabel.text = location.name
        
        switch (location.street, location.number) {
        case (.some, .some):
            streetLabel.text = "\(location.number ?? ""), \(location.street ?? "")"
        case (.some, .none):
            streetLabel.text = "\(location.street ?? "")"
        default:
            streetLabel.text = nil
        }
        
        switch (location.postalCode, location.city) {
        case (.some, .some):
            cityLabel.text = "\(location.postalCode ?? ""), \(location.city ?? "")"
        case (.some, .none):
            cityLabel.text = "\(location.postalCode ?? "")"
        case (.none, .some):
            cityLabel.text = "\(location.city ?? "")"
        default:
            cityLabel.text = nil
        }
        
    }

}
