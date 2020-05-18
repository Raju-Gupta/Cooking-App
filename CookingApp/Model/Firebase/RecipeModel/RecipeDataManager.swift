//
//  RecipeDataManager.swift
//  CookingApp
//
//  Created by Raju Gupta on 15/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeDataManager{
    
    static var recipeData = [RecipeAttributes]()
    static var databaseRef = Database.database().reference()
    
    static func setRecipeData(recipeData: [RecipeAttributes]){
        let ref = databaseRef.child("Recipe").childByAutoId()
        ref.setValue(recipeData[0].toDictionary())
    }
    
    static func getRecipeData(completion: @escaping([RecipeAttributes])->Void){
        var recipeAllData = [RecipeAttributes]()
        databaseRef.child("Recipe").queryOrderedByKey().observe(.value) { (dataSnapShot) in
            if let snapShot = dataSnapShot.children.allObjects as? [DataSnapshot]{
                recipeAllData.removeAll()
                
                for snap in snapShot{
                    if let allData = snap.value as? [String:String]{
                        recipeAllData.append(RecipeAttributes(
                            Ravtar: allData["avtar"]!,
                            Rname: allData["name"]!,
                            Rcategory: allData["category"]!,
                            Rtime: allData["time"]!,
                            Rtype: allData["type"]!,
                            Rpeople: allData["people"]!,
                            Ringredients: allData["ingredients"]!,
                            Rmethod: allData["method"]!,
                            RuserId: allData["userId"]!))
                    }
                }
            }
            completion(recipeAllData)
        }
    }
}
