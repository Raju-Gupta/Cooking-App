//
//  EditProfileViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 23/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgProfileImage: DesignableImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtName: DesignableTextField!
    @IBOutlet weak var txtMobile: DesignableTextField!
    @IBOutlet weak var txtExpert: DesignableTextField!
    @IBOutlet weak var btnGender: DesignableButton!
    @IBOutlet weak var txtBio: DesignableTextView!
    @IBOutlet weak var btnUpdate: DesignableButton!
    
    var userData = [String:Any]()
    let elements = ["Male","Female"]
    var proImg : UIImage? = nil
    let imagePicker = UIImagePickerController()
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSet()
        textViewSetUp()
        textFieldValidation()
        uploadImage()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    @IBAction func onClickGender(_ sender: Any) {
        addDropDown(elements: elements, btn: btnGender, viewContainer: viewContainer)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickUpdate(_ sender: Any) {
        spinnerView.beginRefreshing()
        var imgStr = ""
        if imgProfileImage.image != nil{
            imgStr = DataConvertion.convertImageToBase64String(img: imgProfileImage.image!)
        }
        var bioData = ""
        if txtBio.text != "Describe yourSelf here.... (opt)"{
            bioData = txtBio.text
        }
        var genStr = ""
        if btnGender.titleLabel!.text != "Select Gender (opt)"{
            genStr = btnGender.titleLabel!.text!
        }
        
        UserDataManager.userData.removeAll()
        UserDataManager.userData.append(UserAttributes(Uname: txtName.text!, Uemail: UserDefaultManager.userEmail, Umobile: txtMobile.text ?? "", UrecipeExpert: txtExpert.text ?? "", Ugender: genStr, Ubio: bioData, Uavtar: imgStr))
        UserDataManager.setUserData(userData: UserDataManager.userData, userId: UserDefaultManager.userId)
        spinnerView.endRefreshing()
        navigationController?.popViewController(animated: true)
    }
    
    func userDataSet(){
        txtName.text = userData["name"] as? String
        txtExpert.text = userData["recipeExpert"] as? String
        txtBio.text = userData["bio"] as? String
        txtMobile.text = userData["phone"] as? String
        if userData["gender"] as? String != ""{
            btnGender.setTitle(userData["gender"] as? String, for: .normal)
        }
        imgProfileImage.image = userData["avtar"] as? UIImage
    }
    
}
//MARK: - Profile photo
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Mark: - Adding Tap Gesture to the profile image view.
    func uploadImage(){
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openGallery(_:)))
        imgProfileImage.isUserInteractionEnabled = true
        imgProfileImage.addGestureRecognizer(tap)
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
        proImg = img
        imgProfileImage.image = img
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextView Placeholder Set Up
extension EditProfileViewController: UITextViewDelegate{
    
    func textViewSetUp(){
        if txtBio.text.count == 0{
            txtBio.text = "Describe yourSelf here.... (opt)"
            txtBio.textColor = UIColor.lightGray
            txtBio.delegate = self
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe yourSelf here.... (opt)"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

//MARK: - TextField Validation
extension EditProfileViewController{
    
    func textFieldValidation(){
        btnUpdate.alpha = 1
        TextFieldHelper.textValidation(txt: txtName, regex: RegExManager.nameRegex, error: ErrorMessages.nameError, errorLabel: lblError)
        TextFieldHelper.textValidation(txt: txtMobile, regex: RegExManager.phoneRegex, error: ErrorMessages.phoneError, errorLabel: lblError)
        
        txtName.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtMobile.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtMobile.text?.count == 0{
            if txtName.isSelected == true{
                btnUpdate.alpha = 1
                btnUpdate.isEnabled = true
            }
            else{
                btnUpdate.alpha = 0.5
                btnUpdate.isEnabled = false
            }
        }else{
            if txtName.isSelected == true && txtMobile.isSelected == true{
                btnUpdate.alpha = 1
                btnUpdate.isEnabled = true
            }
            else{
                btnUpdate.alpha = 0.5
                btnUpdate.isEnabled = false
            }
        }
        
    }
}





