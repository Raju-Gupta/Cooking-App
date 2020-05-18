//
//  HeaderCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 20/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var viewContinerView: DesignableView!
    @IBOutlet weak var lblHeading: DesignableLetterSpacing!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
