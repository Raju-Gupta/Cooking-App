//
//  FavoriteDataManager.swift
//  CookingApp
//
//  Created by Raju Gupta on 15/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FavoriteDataManager{
    
    static var recipeData = [RecipeAttributes]()
    static var databaseRef = Database.database().reference()
    
    static func setFavoriteRecipeData(userId:String, recipeData: [RecipeAttributes]){
        let ref = databaseRef.child("Favorite").child(userId).childByAutoId()
        ref.setValue(recipeData[0].toDictionary())
    }
    
    static func getFavoriteRecipeData(userId:String, completion: @escaping([RecipeAttributes])->Void){
        var recipeAllData = [RecipeAttributes]()
        //Imp Note : - using observeSingleEvent (except the block is immediately canceled after the initial data is returned.)
        databaseRef.child("Favorite").child(userId).queryOrderedByKey().observeSingleEvent(of: .value) { (dataSnapShot) in
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
    
    static func removeFavoriteRecipe(userId:String, recipeName : String){
        let removeRef = databaseRef.child("Favorite").child(userId)
        let removeQuery = removeRef.queryOrdered(byChild: "name").queryEqual(toValue: recipeName)
        //Imp Note : - using observeSingleEvent (except the block is immediately canceled after the initial data is returned.)
        removeQuery.observeSingleEvent(of: .value) { (dataSnapShot) in
            if let snapShot = dataSnapShot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    removeRef.child(snap.key).removeValue()
                }
            }
        }
    }
    
    static func removeAllFavoriteRecipes(userId:String){
        databaseRef.child("Favorite").child(userId).removeValue()
    }
}
