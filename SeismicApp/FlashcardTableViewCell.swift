//
//  FlashcardTableViewCell.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/30/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class FlashcardTableViewCell: UITableViewCell {
    
    @IBOutlet var flashcardImage:UIImageView!
    @IBOutlet var name:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
