//
//  SignUpViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 17/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import FirebaseAuth

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var lblErrorLabel: UILabel!
    @IBOutlet weak var txtName: DesignableTextField!
    @IBOutlet weak var txtEmail: DesignableTextField!
    @IBOutlet weak var txtPassword: DesignableTextField!
    @IBOutlet weak var btnSignUp: DesignableButton!
    
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldValidation()
        btnSignUp.isEnabled = false
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        spinnerView.beginRefreshing()
        //Mark:- Firebase Authentication
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            if error != nil{
                self.spinnerView.endRefreshing()
                self.showAlert(title: "Signup Failed", subTitle: error!.localizedDescription, isOKBtnHidden: true)
            }
            else{
                //Mark: - UserDefault Values SetUp
                UserDefaultManager.userDefaultDataSet(isLogin: true, uid: (authResult?.user.uid)!, email: self.txtEmail.text!)
                //Mark: - UserData Saving
                UserDataManager.userData.removeAll()
                UserDataManager.userData.append(UserAttributes(Uname: self.txtName.text!, Uemail: self.txtEmail.text!, Umobile: "", UrecipeExpert: "", Ugender: "", Ubio: "", Uavtar: ""))
                UserDataManager.setUserData(userData: UserDataManager.userData, userId: (authResult?.user.uid)!)
                
                let homeVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RootTabBarController") as! RootTabBarController
                self.spinnerView.endRefreshing()
                self.navigationController?.pushViewController(homeVc, animated: true)
            }
        }
        
    }
    
}

//MARK: - TextField Validation
extension SignUpViewController{
    
    func textFieldValidation(){
        btnSignUp.isEnabled = false
        TextFieldHelper.textValidation(txt: txtName, regex: RegExManager.nameRegex, error: ErrorMessages.nameError, errorLabel: lblErrorLabel)
        TextFieldHelper.textValidation(txt: txtEmail, regex: RegExManager.emailRegex, error: ErrorMessages.emailError, errorLabel: lblErrorLabel)
        TextFieldHelper.textValidation(txt: txtPassword, regex: RegExManager.passwordRegex, error: ErrorMessages.passwordError, errorLabel: lblErrorLabel)
        
        txtName.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtName.isSelected == true && txtEmail.isSelected == true && txtPassword.isSelected == true{
            btnSignUp.alpha = 1
            btnSignUp.isEnabled = true
        }
        else{
            btnSignUp.alpha = 0.5
            btnSignUp.isEnabled = false
        }
    }
}



