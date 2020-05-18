//
//  CategorySliderCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 20/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class CategorySliderCell: UITableViewCell {
    
    @IBOutlet weak var viewContainerView: UIView!
    @IBOutlet weak var categorySliderCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
