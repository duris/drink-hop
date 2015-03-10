//
//  PlaceSelectTableViewCell.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

class PlaceSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel:UILabel!
    @IBOutlet weak var addressNameLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
