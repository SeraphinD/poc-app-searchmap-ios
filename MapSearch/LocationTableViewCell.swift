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
    @IBOutlet private weak var historyImageView: UIImageView!

    var location: Location! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        nameLabel.text = location.name
        streetLabel.text = location.printableStreet
        cityLabel.text = location.printableCity
        historyImageView.isHidden = !location.stored
    }
}
