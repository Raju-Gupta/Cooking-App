//
//  AddCatgoryViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 28/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class AddCatgoryViewController: UIViewController {

    @IBOutlet weak var imgViewCategory: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtCategoryName: DesignableTextField!
    @IBOutlet weak var btnAddCategory: DesignableButton!

    let color = ["FDE497","BEE8FC","E8A08E","E399FF","7EDABF","FAD698","92D88A","FA99C3"]
    var catImg : UIImage? = nil
    let imagePicker = UIImagePickerController()
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldValidation()
        uploadImage()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAddCategory(_ sender: Any) {
        spinnerView.beginRefreshing()
        let randomColor = Int(arc4random_uniform(UInt32(color.count)))
        if imgViewCategory.image == nil{
            lblError.alpha = 1
            lblError.text = "Category image is required."
            spinnerView.endRefreshing()
        }else{
            lblError.alpha = 0
            //Mark: - Image to String Convertion
            let imgStr = DataConvertion.convertImageToBase64String(img: imgViewCategory.image!)
            //Mark: - Category Saving
            CategoryDataManager.categoryData.removeAll()
            CategoryDataManager.categoryData.append(CategoryAttributes(Cavtar: imgStr, Cname: txtCategoryName.text!, Ccolor: color[randomColor]))
            CategoryDataManager.setCategoryData(categoryData: CategoryDataManager.categoryData)
            self.spinnerView.endRefreshing()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - Category photo
extension AddCatgoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Mark: - Adding Tap Gesture to the profile image view.
    func uploadImage(){
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openGallery(_:)))
        imgViewCategory.isUserInteractionEnabled = true
        imgViewCategory.addGestureRecognizer(tap)
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
        catImg = img
        imgViewCategory.image = img
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextField Validation
extension AddCatgoryViewController{
    
    func textFieldValidation(){
        btnAddCategory.isEnabled = false
        TextFieldHelper.textValidation(txt: txtCategoryName, regex: RegExManager.nameRegex, error: ErrorMessages.nameError, errorLabel: lblError)
        
        txtCategoryName.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtCategoryName.isSelected == true{
            btnAddCategory.alpha = 1
            btnAddCategory.isEnabled = true
        }
        else{
            btnAddCategory.alpha = 0.5
            btnAddCategory.isEnabled = false
        }
    }
}

