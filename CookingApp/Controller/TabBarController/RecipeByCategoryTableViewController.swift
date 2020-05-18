//
//  RecipeByCategoryTableViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 15/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class RecipeByCategoryTableViewController: UITableViewController {

    @IBOutlet var RBCtableView: UITableView!
    
    var vcTitle : String?
    var recipeData = [RecipeAttributes]()
    var spinnerView = JTMaterialSpinner()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        spinnerSetUp(spinnerView: spinnerView)
        count = recipeData.count
        self.title = vcTitle
    }
    //MARK: - Cell Registration
    func cellRegister(){
        let empty = UINib.init(nibName: "EmptyCell", bundle: nil)
        RBCtableView.register(empty, forCellReuseIdentifier: "EmptyCell")
        let recipe = UINib.init(nibName: "RecipeCell", bundle: nil)
        RBCtableView.register(recipe, forCellReuseIdentifier: "RecipeCell")
        RBCtableView.tableFooterView = UIView()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Table view data source
extension RecipeByCategoryTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0{
            return 1
        }
        return recipeData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if count == 0{
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            emptyCell.lblText.text = "Sorry, there is no recipe avalaible."
            return emptyCell
        }
        
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipeData[indexPath.row]
        let img = DataConvertion.convertBase64StringToImage(imageBase64String: recipe.avtar)
        recipeCell.lblRecipeName.text = recipe.name
        recipeCell.imgRecipeImage.image = img
        recipeCell.lblHealthy.text = "Healthy"
        recipeCell.lblRecipeForPeople.text = recipe.people
        recipeCell.lblRecipeTime.text = recipe.time
        recipeCell.lblRecipeType.text = recipe.type
        return recipeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        spinnerView.beginRefreshing()
        if count != 0{
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "DetailViewViewController") as! DetailViewViewController
            vc.recipeData = recipeData[indexPath.row]
            spinnerView.endRefreshing()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if count == 0{
            return 896
        }
        return 260
    }
}
