//
//  CategoryDataManager.swift
//  CookingApp
//
//  Created by Raju Gupta on 14/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryDataManager{
    
    static var categoryData = [CategoryAttributes]()
    static var databaseRef = Database.database().reference()
    
    static func setCategoryData(categoryData: [CategoryAttributes]){
        let ref = databaseRef.child("Category").childByAutoId()
        ref.setValue(categoryData[0].toDictionary())
    }
    
    static func getCategoryData(completion: @escaping([CategoryAttributes])->Void){
        var categoryAllData = [CategoryAttributes]()
        databaseRef.child("Category").queryOrderedByKey().observe(.value) { (dataSnapShot) in
            if let snapShot = dataSnapShot.children.allObjects as? [DataSnapshot]{
                categoryAllData.removeAll()
                
                for snap in snapShot{
                    if let allData = snap.value as? [String:String]{
                        categoryAllData.append(CategoryAttributes(
                            Cavtar: allData["avtar"]!,
                            Cname: allData["name"]!,
                            Ccolor: allData["color"]!))
                    }
                }
            }
            completion(categoryAllData)
        }
    }
}
