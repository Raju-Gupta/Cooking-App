//
//  RecipeCell.swift
//  CookingApp
//
//  Created by Raju Gupta on 20/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var ViewBackgroundView: UIView!
    @IBOutlet weak var ViewContainerView: DesignableView!
    @IBOutlet weak var imgRecipeImage: UIImageView!
    @IBOutlet weak var lblHealthy: UILabel!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblRecipeTime: UILabel!
    @IBOutlet weak var lblRecipeType: UILabel!
    @IBOutlet weak var lblRecipeForPeople: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
