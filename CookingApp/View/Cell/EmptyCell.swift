//
//  EmptyCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 22/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {

    @IBOutlet weak var emptyIcon: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
