//
//  ProfileViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 22/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgProfileImage: DesignableImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExpert: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    var spinnerView = JTMaterialSpinner()
    
    let sectionArr = ["Personal Info","Bio","Settings"]
    var infoArr = [String]()
    var bio : String?
    let settingArr = ["My All Recipe","Logout","Delete Account"]
    var userInfo = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
        spinnerSetUp(spinnerView: spinnerView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpUserData()
    }
    
    //MARK: - TableView Cell Register
    func cellRegister(){
        let header = UINib.init(nibName: "HeaderCell", bundle: nil)
        profileTableView.register(header, forCellReuseIdentifier: "HeaderCell")
        let text = UINib.init(nibName: "TextCell", bundle: nil)
        profileTableView.register(text, forCellReuseIdentifier: "TextCell")
        let setting = UINib.init(nibName: "SettingCell", bundle: nil)
        profileTableView.register(setting, forCellReuseIdentifier: "SettingCell")
        profileTableView.tableFooterView = UIView()
        profileTableView.estimatedRowHeight = 35
        profileTableView.rowHeight = UITableView.automaticDimension
    }
    //MARK: - User Data Set Up
    func setUpUserData(){
        spinnerView.beginRefreshing()
        UserDataManager.getUserData(userId: UserDefaultManager.userId) { (userData) in
            self.lblName.text = userData[0].name
            self.lblExpert.text = userData[0].recipeExpert
            self.bio = userData[0].bio
            
            self.infoArr.removeAll()
            self.infoArr.append(userData[0].email!)
            if userData[0].phone != ""{
                self.infoArr.append(userData[0].phone!)
            }
            if userData[0].gender != ""{
                self.infoArr.append(userData[0].gender!)
            }
            self.profileTableView.reloadData()
            
            if userData[0].avtar != ""{
                self.imgProfileImage.image = DataConvertion.convertBase64StringToImage(imageBase64String: userData[0].avtar!)
                self.userInfo = ["name": userData[0].name!, "recipeExpert": userData[0].recipeExpert ?? "", "bio": userData[0].bio ?? "", "email": userData[0].email!, "phone": userData[0].phone ?? "", "gender": userData[0].gender ?? "", "avtar": self.imgProfileImage.image!]
            }else{
                self.userInfo = ["name": userData[0].name!, "recipeExpert": userData[0].recipeExpert ?? "", "bio": userData[0].bio ?? "", "email": userData[0].email!, "phone": userData[0].phone ?? "", "gender": userData[0].gender ?? "", "avtar": UIImage()]
            }
            self.spinnerView.endRefreshing()
        }
    }
    
    @IBAction func onClickEditProfile(_ sender: Any) {
        
        let editPro = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
        editPro.userData = userInfo
        self.navigationController?.pushViewController(editPro, animated: true)
    }
    
}

//MARK: - TableView Func
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionindex = sectionTitleIndex(rawValue: section){
            switch sectionindex {
            case .PersonalInfo:
                return infoArr.count
            case .Bio:
                return 1
            case .Setting:
                return settingArr.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let sectionIndex = sectionTitleIndex(rawValue: indexPath.section){
            switch sectionIndex {
            case .PersonalInfo:
                let infoCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                infoCell.lblText.text = infoArr[indexPath.row]
                return infoCell
            case .Bio:
                let bioCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                bioCell.lblText.text = bio
                return bioCell
            case .Setting:
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
                if indexPath.row == 1 || indexPath.row == 2{
                    settingCell.lblSettingText.textColor = UIColor.red
                }
                settingCell.lblSettingText.text = settingArr[indexPath.row]
                return settingCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                RecipeDataManager.getRecipeData { (allRecipe) in
                    let myRecipe = allRecipe.filter{$0.userId.contains(UserDefaultManager.userId)}
                    let vc = UIStoryboard(name: "Category", bundle: nil).instantiateViewController(identifier: "RecipeByCategoryTableViewController") as! RecipeByCategoryTableViewController
                    vc.recipeData = myRecipe
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                showAlert(title: "Logout", subTitle: "Are you sure?, you want to logout.", isOKBtnHidden: false)
            case 2:
                showAlert(title: "Delete Account", subTitle: "Are you sure?, you want to delete your account; It will gonna delete all your user data and all your favorites recipes.", isOKBtnHidden: false)
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionIndex = sectionTitleIndex(rawValue: indexPath.section){
            switch sectionIndex {
            case .PersonalInfo:
                return 40
            case .Bio:
                return UITableView.automaticDimension
            case .Setting:
                return 45
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.lblHeading.text = sectionArr[section]
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

extension ProfileViewController{
    enum sectionTitleIndex: Int  {
        case PersonalInfo = 0
        case Bio = 1
        case Setting = 2
    }
}
