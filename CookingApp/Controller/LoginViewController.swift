//
//  LoginViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 17/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import FirebaseAuth

class LoginViewController: BaseViewController{
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtEmail: DesignableTextField!
    @IBOutlet weak var txtPassword: DesignableTextField!
    @IBOutlet weak var btnLogin: DesignableButton!
    
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldValidation()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        spinnerView.beginRefreshing()
        //Mark:- Firebase Authentication
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            if error != nil{
                self.spinnerView.endRefreshing()
                self.showAlert(title: "Login Failed", subTitle: error!.localizedDescription, isOKBtnHidden: true)
            }
            else{
                //Mark: - UserDefault Values SetUp
                UserDefaultManager.userDefaultDataSet(isLogin: true, uid: (authResult?.user.uid)!, email: self.txtEmail.text!)
                
                let homeVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RootTabBarController") as! RootTabBarController
                self.spinnerView.endRefreshing()
                self.navigationController?.pushViewController(homeVc, animated: true)
            }
        }
    }
    
    
}

//MARK: - TextField Validation
extension LoginViewController{
    
    func textFieldValidation(){
        btnLogin.isEnabled = false
        TextFieldHelper.textValidation(txt: txtEmail, regex: RegExManager.emailRegex, error: ErrorMessages.emailError, errorLabel: lblError)
        TextFieldHelper.textValidation(txt: txtPassword, regex: RegExManager.passwordRegex, error: ErrorMessages.passwordError, errorLabel: lblError)
        
        txtEmail.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtEmail.isSelected == true && txtPassword.isSelected == true{
            btnLogin.alpha = 1
            btnLogin.isEnabled = true
        }
        else{
            btnLogin.alpha = 0.5
            btnLogin.isEnabled = false
        }
    }
}
