//
//  DetailViewViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 27/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class DetailViewViewController: UIViewController {
    
    @IBOutlet weak var imgRecipeImage: UIImageView!
    @IBOutlet weak var lblRecipeCategoryName: UILabel!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblRecipeTime: UILabel!
    @IBOutlet weak var lblRecipeType: UILabel!
    @IBOutlet weak var lblRecipeForPeople: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    var spinnerView = JTMaterialSpinner()
    var recipeData : RecipeAttributes?
    var sectionArr = ["INGRIEDIENT", "HOW TO PREPARE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        dataSetUp()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setFavoriteBtnStatus()
    }
    
    // MARK: - Cell Register
    func cellRegister(){
        let header = UINib.init(nibName: "HeaderCell", bundle: nil)
        detailTableView.register(header, forCellReuseIdentifier: "HeaderCell")
        let text = UINib.init(nibName: "TextCell", bundle: nil)
        detailTableView.register(text, forCellReuseIdentifier: "TextCell")
        
        detailTableView.estimatedRowHeight = 35
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.tableFooterView = UIView()
    }
    
    // MARK: - Controller Data Set Up
    func dataSetUp(){
        imgRecipeImage.image = DataConvertion.convertBase64StringToImage(imageBase64String: recipeData!.avtar)
        lblRecipeCategoryName.text = recipeData?.category
        lblRecipeName.text = recipeData?.name
        lblRecipeTime.text = recipeData?.time
        lblRecipeType.text = recipeData?.type
        lblRecipeForPeople.text = recipeData?.people
    }
    
    // MARK: - Setting Favorite btn Status
    func setFavoriteBtnStatus(){
        spinnerView.beginRefreshing()
        FavoriteDataManager.getFavoriteRecipeData(userId: UserDefaultManager.userId) { (AllFavRecipes) in
            for recipe in AllFavRecipes{
                if self.recipeData?.name == recipe.name{
                    self.btnFavorite.image = UIImage(systemName: "heart.fill")
                    self.btnFavorite.tintColor = .red
                    self.detailTableView.reloadData()
                    self.spinnerView.endRefreshing()
                }
                else{
                    self.btnFavorite.image = UIImage(systemName: "heart")
                    self.btnFavorite.tintColor = .black
                    self.detailTableView.reloadData()
                    self.spinnerView.endRefreshing()
                }
            }
            self.spinnerView.endRefreshing()
        }
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickFavorite(_ sender: Any) {
        if btnFavorite.tintColor == UIColor.black{
            spinnerView.beginRefreshing()
            // MARK: - Adding to Favorite List
            FavoriteDataManager.recipeData.removeAll()
            FavoriteDataManager.recipeData.append(RecipeAttributes(Ravtar: recipeData!.avtar, Rname: recipeData!.name, Rcategory: recipeData!.category, Rtime: recipeData!.time, Rtype: recipeData!.type, Rpeople: recipeData!.people, Ringredients: recipeData!.ingredients, Rmethod: recipeData!.method, RuserId: UserDefaultManager.userId))
            FavoriteDataManager.setFavoriteRecipeData(userId: UserDefaultManager.userId, recipeData: FavoriteDataManager.recipeData)
            
            btnFavorite.image = UIImage(systemName: "heart.fill")
            btnFavorite.tintColor = .red
            spinnerView.endRefreshing()
        }
        else{
            spinnerView.beginRefreshing()
            // MARK: - Removing from Favorite List
            FavoriteDataManager.removeFavoriteRecipe(userId: UserDefaultManager.userId, recipeName: recipeData!.name)
            
            btnFavorite.image = UIImage(systemName: "heart")
            btnFavorite.tintColor = .black
            spinnerView.endRefreshing()
        }
    }
}

//MARK: - Table View Cell
extension DetailViewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let sectionTitle = sectionTitleIndex(rawValue: indexPath.section){
            switch sectionTitle {
            case .ingredient:
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                sectionCell.lblText.attributedText = DataConvertion.newAttrSize(blockQuote: recipeData!.ingredients.htmlToAttributedString!)
                return sectionCell
            case .methos:
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                sectionCell.lblText.attributedText = DataConvertion.newAttrSize(blockQuote: recipeData!.method.htmlToAttributedString!)
                return sectionCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.lblHeading.text = sectionArr[section]
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}

extension DetailViewViewController{
    enum sectionTitleIndex: Int {
        case ingredient = 0
        case methos = 1
    }
}
