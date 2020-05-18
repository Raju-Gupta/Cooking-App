//
//  FavoritesTableViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 22/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class FavoritesTableViewController: UITableViewController {
    
    @IBOutlet var favTableView: UITableView!
    var count = 0
    var allFavoriteRecipes = [RecipeAttributes]()
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        spinnerSetUp(spinnerView: spinnerView)
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllFavoriteRecipes()
    }
    //MARK: - Cell Registration
    func cellRegister(){
        let empty = UINib.init(nibName: "EmptyCell", bundle: nil)
        favTableView.register(empty, forCellReuseIdentifier: "EmptyCell")
        let recipe = UINib.init(nibName: "RecipeCell", bundle: nil)
        favTableView.register(recipe, forCellReuseIdentifier: "RecipeCell")
        favTableView.tableFooterView = UIView()
    }
    //MARK: - Favorite Recipe Data Loading
    func getAllFavoriteRecipes(){
        spinnerView.beginRefreshing()
        allFavoriteRecipes.removeAll()
        FavoriteDataManager.getFavoriteRecipeData(userId: UserDefaultManager.userId) { (favoriteRecipes) in
            self.allFavoriteRecipes = favoriteRecipes
            self.count = self.allFavoriteRecipes.count
            self.favTableView.reloadData()
            self.spinnerView.endRefreshing()
        }
    }
    
}

// MARK: - Table view data source
extension FavoritesTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0{
            return 1
        }
        return allFavoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if count == 0{
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            return emptyCell
        }
        
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        //let recipe = allFavoriteRecipes[indexPath.row]
        let img = DataConvertion.convertBase64StringToImage(imageBase64String: allFavoriteRecipes[indexPath.row].avtar)
        recipeCell.lblRecipeName.text = allFavoriteRecipes[indexPath.row].name
        recipeCell.imgRecipeImage.image = img
        recipeCell.lblHealthy.text = "Healthy"
        recipeCell.lblRecipeForPeople.text = allFavoriteRecipes[indexPath.row].people
        recipeCell.lblRecipeTime.text = allFavoriteRecipes[indexPath.row].time
        recipeCell.lblRecipeType.text = allFavoriteRecipes[indexPath.row].type
        return recipeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if count != 0{
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "DetailViewViewController") as! DetailViewViewController
            vc.recipeData = allFavoriteRecipes[indexPath.row]
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
