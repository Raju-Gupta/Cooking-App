//
//  UserDataManager.swift
//  CookingApp
//
//  Created by Raju Gupta on 12/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserDataManager{
    
    static var userData = [UserAttributes]()
    static var databaseRef = Database.database().reference()
    
    static func setUserData(userData: [UserAttributes], userId: String){
        let ref = databaseRef.child("User").child(userId)
        ref.setValue(userData[0].toDictionary())
    }
    
    static func getUserData(userId: String ,completion: @escaping([UserAttributes])->Void){
        
        var data = [UserAttributes]()
        
        databaseRef.child("User").child(userId).observeSingleEvent(of: .value) { (dataSnapShot) in
            if let snapShot = dataSnapShot.value as? NSDictionary{
                data.removeAll()
                data.append(UserAttributes(
                    Uname: snapShot["name"] as! String,
                    Uemail: snapShot["email"] as! String,
                    Umobile: snapShot["phone"] as? String ?? "",
                    UrecipeExpert: snapShot["recipeExpert"] as? String ?? "",
                    Ugender: snapShot["gender"] as? String ?? "",
                    Ubio: snapShot["bio"] as? String ?? "",
                    Uavtar: snapShot["avtar"] as? String ?? ""))
                
                completion(data)
            }
        }
    }
    
    static func removeUserData(userId:String){
        databaseRef.child("User").child(userId).removeValue()
    }
    
}
