//
//  TextCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 22/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
