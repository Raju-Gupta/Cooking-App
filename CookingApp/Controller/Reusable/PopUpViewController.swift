//
//  PopUpViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 19/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import FirebaseAuth

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var viewMenuView: DesignableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PopUpSetUp()
    }
    
    func PopUpSetUp(){
        let attribute = PopUpAttribute.share.attributes[0]
        lblTitle.text = attribute.title
        lblSubTitle.text = attribute.subTitle
        btnYes.isHidden = attribute.btnEnable
    }
    
    @IBAction func onClickDimiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickYes(_ sender: Any) {
        if lblTitle.text == "Logout"{
            do{
                try Auth.auth().signOut()
                setRootVC()
            }
            catch let err{
                print(err.localizedDescription)
            }
        }
        else{
            UserDataManager.removeUserData(userId: UserDefaultManager.userId)
            FavoriteDataManager.removeAllFavoriteRecipes(userId: UserDefaultManager.userId)
            let currentUser = Auth.auth().currentUser
            currentUser?.delete(completion: { (error) in
                if error != nil{
                    print("error== \(error!.localizedDescription)")
                }
                else{
                    self.setRootVC()
                }
            })
        }
        
    }
    
    @IBAction func onClickCancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    func setRootVC(){
        UserDefaultManager.removeAll()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartingViewController") as! StartingViewController
        let navVc = UINavigationController(rootViewController: vc)
        navVc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVc.navigationBar.shadowImage = UIImage()
        navVc.navigationBar.isTranslucent = true
        let appDel = UIApplication.shared.delegate as? AppDelegate
        appDel?.window?.rootViewController = navVc
    }
}
