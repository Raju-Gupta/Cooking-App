//
//  CategoryCollectionViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 21/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class CategoryCollectionViewController: UICollectionViewController {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    var categoryData = [CategoryAttributes]()
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        SetUpCategoryData()
        spinnerSetUp(spinnerView: spinnerView)
    }
    //MARK: - Cell Registration
    func cellRegister(){
        let categoryNib = UINib.init(nibName: "CategoryCell", bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: "CategoryCell")
    }
    //MARK: - Category data Loading
    func SetUpCategoryData(){
        spinnerView.beginRefreshing()
        categoryData.removeAll()
        CategoryDataManager.getCategoryData { (categorAllyData) in
            self.categoryData = categorAllyData
            self.categoryCollectionView.reloadData()
            self.spinnerView.endRefreshing()
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension CategoryCollectionViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let img = DataConvertion.convertBase64StringToImage(imageBase64String: categoryData[indexPath.row].avtar)
        cell.viewContainerView.backgroundColor = UIColor(hexString: categoryData[indexPath.row].color)
        cell.lblCategoryName.text = categoryData[indexPath.row].name
        cell.imgCategoryImage.image = img
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        spinnerView.beginRefreshing()
        let vc = UIStoryboard(name: "Category", bundle: nil).instantiateViewController(identifier: "RecipeByCategoryTableViewController") as! RecipeByCategoryTableViewController
        
        vc.vcTitle = categoryData[indexPath.row].name
        
        RecipeDataManager.getRecipeData { (recipeData) in
            let recipes:[RecipeAttributes] =  recipeData.filter{$0.category.contains(self.categoryData[indexPath.row].name)}
            vc.recipeData = recipes
            self.spinnerView.endRefreshing()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FlowLayout Func
extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let customWidth = (collectionView.bounds.width/2)
        let customHeight = collectionView.bounds.width/2
        return CGSize(width: customWidth - 22.5, height: customHeight)
        //Left + Right + minimumInteritemSpacingForSectionAt = 22.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 7.5
        //7.5 + 7.5 = 15 Mibble Space  //always minus from collection view bound width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        // letf + right = 30  //always minus from collection view bound width
    }
}
