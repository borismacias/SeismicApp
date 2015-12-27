//
//  LatestEarthquakeTableViewCell.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/26/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class LatestEarthquakeTableViewCell: UITableViewCell {
    
    @IBOutlet var placeLabel:UILabel!
    @IBOutlet var magnitudeLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
