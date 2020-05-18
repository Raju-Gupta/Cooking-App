//
//  ForgotPasswordViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 17/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import FirebaseAuth

class ForgotPasswordViewController: UIViewController{
    @IBOutlet weak var lblErrorLabel: UILabel!
    @IBOutlet weak var txtEmail: DesignableTextField!
    @IBOutlet weak var btnSubmit: DesignableButton!
    
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldValidation()
        spinnerSetUp(spinnerView: spinnerView)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        spinnerView.beginRefreshing()
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { (error) in
            if error != nil{
                self.spinnerView.endRefreshing()
                self.showAlert(title: "Failed", subTitle: error!.localizedDescription, isOKBtnHidden: true)
            }
            else{
                self.spinnerView.endRefreshing()
                self.showAlert(title: "Reset Link send successfully", subTitle: "We have just send you a password reset email. Please check your inbox and follow the instructions to reset you password.", isOKBtnHidden: true)
            }
        }
    }
    
}

//MARK: - TextField Validation
extension ForgotPasswordViewController{
    
    func textFieldValidation(){
        btnSubmit.isEnabled = false
        
        TextFieldHelper.textValidation(txt: txtEmail, regex: RegExManager.emailRegex, error: ErrorMessages.emailError, errorLabel: lblErrorLabel)
    
        txtEmail.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textfieldDidChange(_ sender: UITextField){
        if txtEmail.isSelected == true{
            btnSubmit.alpha = 1
            btnSubmit.isEnabled = true
        }
        else{
            btnSubmit.alpha = 0.5
            btnSubmit.isEnabled = false
        }
    }
}




