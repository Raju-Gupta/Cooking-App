//
//  AddRecipeMethodViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 27/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import RichEditorView

class AddRecipeIngredientViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewIngredients: RichEditorView!
    @IBOutlet weak var btnNext: DesignableButton!
    
    var ing : String?
    var recipeInfoArr = [RecipeAttributes]()
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        var recipeData = [RecipeAttributes]()
        let recipe = recipeInfoArr[0]
        recipeData.append(RecipeAttributes(Ravtar: recipe.avtar, Rname: recipe.name, Rcategory: recipe.category, Rtime: recipe.time, Rtype: recipe.type, Rpeople: recipe.people, Ringredients: ing!, Rmethod: "", RuserId: ""))
        let vc = storyboard?.instantiateViewController(identifier:  "AddRecipeMethodViewController") as! AddRecipeMethodViewController
        vc.recipeData = recipeData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickRegign(_ sender: Any){
       _ = viewIngredients.resignFirstResponder()
    }
    
    func viewSetUp(){
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        viewContainer.layer.cornerRadius = 5
        btnNext.isEnabled = false
        editorSetUp(view: viewIngredients, placeholder: "Ingredients name here.....")
    }
    //MARK: - Editor Setup
    func editorSetUp(view: RichEditorView, placeholder:String){
        view.delegate = self
        view.inputAccessoryView = toolbar
        view.placeholder = placeholder
        
        toolbar.delegate = self
        toolbar.editor = view
        
        let item = RichEditorOptionItem(image: nil, title: "Done") { toolbar in
            _ = self.viewIngredients.resignFirstResponder()
        }
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
    }
}


//MARK: - RichEditorDelegate
extension AddRecipeIngredientViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            btnNext.alpha = 0.5
            btnNext.isEnabled = false
        } else {
            btnNext.alpha = 1
            btnNext.isEnabled = true
            ing = content
        }
    }
    
}
//MARK: - RichEditorToolbarDelegate
extension AddRecipeIngredientViewController: RichEditorToolbarDelegate {

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
