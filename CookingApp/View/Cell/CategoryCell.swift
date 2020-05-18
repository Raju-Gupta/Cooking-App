//
//  CategoryCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 21/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var viewContainerView: DesignableView!
    @IBOutlet weak var imgCategoryImage: DesignableImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
