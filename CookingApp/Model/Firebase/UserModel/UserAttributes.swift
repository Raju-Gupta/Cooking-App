//
//  UserAttributes.swift
//  CookingApp
//
//  Created by Raju Gupta on 12/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class UserAttributes{
    var name : String?
    var email : String?
    var phone : String?
    var recipeExpert : String?
    var gender : String?
    var bio : String?
    var avtar : String?
    
    init(Uname:String, Uemail:String, Umobile:String, UrecipeExpert:String, Ugender:String, Ubio:String, Uavtar:String){
        self.name = Uname
        self.email = Uemail
        self.phone = Umobile
        self.recipeExpert = UrecipeExpert
        self.gender = Ugender
        self.bio = Ubio
        self.avtar = Uavtar
    }
    
    func toDictionary() -> Any {
        return ["name":name, "email": email, "phone": phone, "recipeExpert": recipeExpert, "gender": gender, "bio": bio, "avtar": avtar] as Any
    }
}


