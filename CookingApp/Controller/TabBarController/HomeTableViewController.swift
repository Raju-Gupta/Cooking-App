//
//  HomeTableViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 20/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner


enum HeaderTitleIndex : Int{
    case Category = 0
    case Latest = 1
}

class HomeTableViewController: UITableViewController{
    @IBOutlet var homeTableView: UITableView!
    @IBOutlet weak var addRecipeBtn: UIBarButtonItem!
    var categoryAllData = [CategoryAttributes]()
    var recipeAllData = [RecipeAttributes]()
    var sectionTitle = ["Category", "Latest"]
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        setCategoryData()
        setRecipeData()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    //MARK: - Cell Registration
    func cellRegister(){
        let header = UINib.init(nibName: "HeaderCell", bundle: nil)
        homeTableView.register(header, forCellReuseIdentifier: "HeaderCell")
        let recipe = UINib.init(nibName: "RecipeCell", bundle: nil)
        homeTableView.register(recipe, forCellReuseIdentifier: "RecipeCell")
        let categorySlider = UINib.init(nibName: "CategorySliderCell", bundle: nil)
        homeTableView.register(categorySlider, forCellReuseIdentifier: "CategorySliderCell")
    }
    
    @IBAction func onClickAddRecipe(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddRecipeInfoViewController") as! AddRecipeInfoViewController
        vc.categoryArr = categoryAllData.map{$0.name}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Category Data Loading
    func setCategoryData(){
        spinnerView.beginRefreshing()
        addRecipeBtn.isEnabled = false
        categoryAllData.removeAll()
        CategoryDataManager.getCategoryData { (categoryData) in
            self.categoryAllData = categoryData
            let collectionView = self.homeTableView.viewWithTag(1) as? UICollectionView
            collectionView?.reloadData()
            self.addRecipeBtn.isEnabled = true
        }
    }
    
    //MARK: - Recipe Data Loading
    func setRecipeData(){
        recipeAllData.removeAll()
        RecipeDataManager.getRecipeData { (recipeData) in
            self.recipeAllData = recipeData
            self.homeTableView.reloadData()
            self.spinnerView.endRefreshing()
        }
    }

}

// MARK: - Table view Func
extension HomeTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sectionIndex = HeaderTitleIndex(rawValue: section){
            switch sectionIndex {
            case .Category:
                return 1
            case .Latest:
                return recipeAllData.count
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        
        if let sectionIndex = HeaderTitleIndex(rawValue: indexPath.section){
            switch sectionIndex {
                
            case .Category:
                let categorySlidercell = tableView.dequeueReusableCell(withIdentifier: "CategorySliderCell", for: indexPath) as! CategorySliderCell
                return categorySlidercell
                
            case .Latest:
                let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
                let recipe = recipeAllData[indexPath.row]
                let img = DataConvertion.convertBase64StringToImage(imageBase64String: recipe.avtar)
                recipeCell.lblRecipeName.text = recipe.name
                recipeCell.imgRecipeImage.image = img
                recipeCell.lblHealthy.text = "Healthy"
                recipeCell.lblRecipeForPeople.text = recipe.people
                recipeCell.lblRecipeTime.text = recipe.time
                recipeCell.lblRecipeType.text = recipe.type
                return recipeCell
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewViewController") as! DetailViewViewController
        vc.recipeData = recipeAllData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let categorySliderCell = cell as? CategorySliderCell
        categorySliderCell?.categorySliderCollectionView.delegate = self
        categorySliderCell?.categorySliderCollectionView.dataSource = self
        let sliderCell = UINib.init(nibName: "CategorySliderCollectionViewCell", bundle: nil)
        categorySliderCell?.categorySliderCollectionView.register(sliderCell, forCellWithReuseIdentifier: "CategorySliderCollectionViewCell")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let sectionIndex = HeaderTitleIndex(rawValue: indexPath.section){
            switch sectionIndex {
            case .Category:
                return 160
            case .Latest:
                return 260
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.lblHeading.text = sectionTitle[section]
        return headerCell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}

// MARK: - Collection view Func
extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryAllData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySliderCollectionViewCell", for: indexPath) as! CategorySliderCollectionViewCell
        let img = DataConvertion.convertBase64StringToImage(imageBase64String: categoryAllData[indexPath.row].avtar)
        cell.lblCategorySliderName.text = categoryAllData[indexPath.row].name
        cell.viewContainerView.backgroundColor = UIColor(hexString: categoryAllData[indexPath.row].color)
        cell.imgCategorySliderImage.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        spinnerView.beginRefreshing()
        let vc = UIStoryboard(name: "Category", bundle: nil).instantiateViewController(identifier: "RecipeByCategoryTableViewController") as! RecipeByCategoryTableViewController
        vc.vcTitle = categoryAllData[indexPath.row].name
        RecipeDataManager.getRecipeData { (recipeData) in
            let recipes:[RecipeAttributes] =  recipeData.filter{$0.category.contains(self.categoryAllData[indexPath.row].name)}
            vc.recipeData = recipes
            self.spinnerView.endRefreshing()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 380, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

 //MARK: - Centering Slider
extension HomeTableViewController{
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //let collectionView = self.homeTableView.viewWithTag(1) as? UICollectionView
        let cellItemWidth = self.homeTableView.frame.width - (16 + 16) // (insetForSection.left + insetForSection.right)
        let pageWidth = Float(cellItemWidth + 10) // (cellItemWidth + minimumLineSpacing)
        let offsetXAfterDragging = Float(scrollView.contentOffset.x)
        let targetOffsetX = Float(targetContentOffset.pointee.x)
        let pagesCountForOffset = pagesCount(forOffset: offsetXAfterDragging, withTargetOffset: targetOffsetX, pageWidth: pageWidth)
        var newTargetOffsetX = pagesCountForOffset * pageWidth
        keepNewTargetInBounds(&newTargetOffsetX, scrollView)
        targetContentOffset.pointee.x = CGFloat(offsetXAfterDragging)
        let newTargetPoint = CGPoint(x: CGFloat(newTargetOffsetX), y: scrollView.contentOffset.y)
        scrollView.setContentOffset(newTargetPoint, animated: true)
    }
    
    fileprivate func pagesCount(forOffset offset: Float, withTargetOffset targetOffset: Float, pageWidth: Float) -> Float {
        let isRightDirection = targetOffset > offset
        let roundFunction = isRightDirection ? ceilf : floorf
        let pagesCountForOffset = roundFunction(offset / pageWidth)
        return pagesCountForOffset
    }
    
    fileprivate func keepNewTargetInBounds(_ newTargetOffsetX: inout Float, _ scrollView: UIScrollView) {
        if newTargetOffsetX < 0 { newTargetOffsetX = 0 }
        let contentSizeWidth = Float(scrollView.contentSize.width)
        if newTargetOffsetX > contentSizeWidth { newTargetOffsetX = contentSizeWidth }
    }
}


