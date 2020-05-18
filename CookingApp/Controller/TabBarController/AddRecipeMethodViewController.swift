//
//  AddRecipeMethodViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 18/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import RichEditorView

class AddRecipeMethodViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewMethod : RichEditorView!
    @IBOutlet weak var btnAdd: DesignableButton!
    
    var recipeData = [RecipeAttributes]()
    var method : String?
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
    }
    
    @IBAction func onClickBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAdd(_ sender: Any){
        RecipeDataManager.recipeData.removeAll()
        let recipe = recipeData[0]
        RecipeDataManager.recipeData.append(RecipeAttributes(Ravtar: recipe.avtar, Rname: recipe.name, Rcategory: recipe.category, Rtime: recipe
            .time, Rtype: recipe.type, Rpeople: recipe.people, Ringredients: recipe.ingredients, Rmethod: method!, RuserId: UserDefaultManager.userId))
        RecipeDataManager.setRecipeData(recipeData: RecipeDataManager.recipeData)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickRegign(_ sender: Any){
        _ = self.viewMethod.resignFirstResponder()
    }
    
    func viewSetUp(){
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        viewContainer.layer.cornerRadius = 5
        btnAdd.isEnabled = false
        editorSetUp(view: viewMethod, placeholder: "Preparation method here.....")
    }
    //MARK: - Editor SetUp
    func editorSetUp(view: RichEditorView, placeholder:String){
        view.delegate = self
        view.inputAccessoryView = toolbar
        view.placeholder = placeholder
        
        toolbar.delegate = self
        toolbar.editor = view
        
        let item = RichEditorOptionItem(image: nil, title: "Done") { toolbar in
           _ = self.viewMethod.resignFirstResponder()
        }
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
    }

}

//MARK: - RichEditorDelegate
extension AddRecipeMethodViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            btnAdd.alpha = 0.5
            btnAdd.isEnabled = false
        } else {
            btnAdd.alpha = 1
            btnAdd.isEnabled = true
            method = content
        }
    }
    
}
//MARK: - RichEditorToolbarDelegate
extension AddRecipeMethodViewController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [#colorLiteral(red: 0.8003904371, green: 0.9808781273, blue: 1, alpha: 1)]
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

}
