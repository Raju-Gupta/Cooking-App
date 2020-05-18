//
//  AddRecipeInfoViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 27/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class AddRecipeInfoViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var ImgViewRecipe: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtRecipeName: DesignableTextField!
    @IBOutlet weak var btnRecipeCategory: DesignableButton!
    @IBOutlet weak var btnRecipeTime: DesignableButton!
    @IBOutlet weak var btnRecipeType: DesignableButton!
    @IBOutlet weak var btnRecipeForPeople: DesignableButton!
    @IBOutlet weak var btnNext: DesignableButton!
    var categoryArr = [String]()
    var recipeImg : UIImage? = nil
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getCategoryNameList()
        textFieldValidation()
        uploadImage()
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //Mark : - Adding DropDown List to all this button
    @IBAction func onClickRecipeCategory(_ sender: Any) {
        addDropDown(elements: categoryArr, btn: btnRecipeCategory, viewContainer: viewContainer)
    }
    @IBAction func onClickRecipeTime(_ sender: Any) {
        addDropDown(elements: ["30 Minutes","1 Hours", "1.5 Hours", "2 Hours", "2.5 Hours"], btn: btnRecipeTime, viewContainer: viewContainer)
    }
    @IBAction func onClickRecipeType(_ sender: Any) {
        addDropDown(elements: ["Easy","Nomal","Hard"], btn: btnRecipeType, viewContainer: viewContainer)
    }
    @IBAction func onClickRecipeForPeople(_ sender: Any) {
        addDropDownUpSide(elements: ["1 People", "2 Peoples", "3 Peoples","4 Peoples","5 Peoples","6 Peoples"], btn: btnRecipeForPeople, viewContainer: viewContainer)
    }
    
    
    @IBAction func onClickNext(_ sender: Any) {
        if ImgViewRecipe.image == nil || btnRecipeCategory.titleLabel?.text == "Select Category*" || btnRecipeTime.titleLabel?.text == "Select Recipe Time*" || btnRecipeType.titleLabel?.text == "Select Recipe Type*" || btnRecipeForPeople.titleLabel?.text == "Select Recipe For People*"{
            lblError.alpha = 1
            lblError.text = "All fields are required."
        }
        else{
            lblError.alpha = 0
            
            let imgStr = DataConvertion.convertImageToBase64String(img: ImgViewRecipe.image!)
            
            var recipeInfo = [RecipeAttributes]()
            recipeInfo.append(RecipeAttributes(Ravtar: imgStr, Rname: txtRecipeName.text!, Rcategory: btnRecipeCategory.titleLabel!.text!, Rtime: btnRecipeTime.titleLabel!.text!, Rtype: btnRecipeType.titleLabel!.text!, Rpeople: btnRecipeForPeople.titleLabel!.text!, Ringredients: "", Rmethod: "", RuserId: ""))
            let methodVc = storyboard?.instantiateViewController(identifier: "AddRecipeIngredientViewController") as! AddRecipeIngredientViewController
            methodVc.recipeInfoArr = recipeInfo
            navigationController?.pushViewController(methodVc, animated: true)
        }
    }
}

//MARK: - Recipe photo Upload
extension AddRecipeInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Mark: - Adding Tap Gesture to the profile image view.
    func uploadImage(){
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openGallery(_:)))
        ImgViewRecipe.isUserInteractionEnabled = true
        ImgViewRecipe.addGestureRecognizer(tap)
    }
    
    @objc func openGallery(_ tapgesture : UITapGestureRecognizer){
        setUpImagePicker()
    }
    
    func setUpImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Mark: - UIImagePickerControllerDelegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        recipeImg = img
        ImgViewRecipe.image = img
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - TextField Validation
extension AddRecipeInfoViewController{
    
    func textFieldValidation(){
        btnNext.isEnabled = false
        TextFieldHelper.textValidation(txt: txtRecipeName, regex: RegExManager.nameRegex, error: ErrorMessages.nameError, errorLabel: lblError)
        
        txtRecipeName.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtRecipeName.isSelected == true{
            btnNext.alpha = 1
            btnNext.isEnabled = true
        }
        else{
            btnNext.alpha = 0.5
            btnNext.isEnabled = false
        }
    }
}
