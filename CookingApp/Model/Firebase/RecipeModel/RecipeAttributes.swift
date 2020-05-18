//
//  RecipeAttributes.swift
//  CookingApp
//
//  Created by Raju Gupta on 15/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class RecipeAttributes{
    let avtar : String
    let name : String
    let category : String
    let time : String
    let type : String
    let people : String
    let ingredients : String
    let method : String
    let userId : String
    
    init(Ravtar: String, Rname: String, Rcategory: String, Rtime: String, Rtype: String, Rpeople: String, Ringredients: String, Rmethod: String, RuserId: String){
        self.avtar = Ravtar
        self.name = Rname
        self.category = Rcategory
        self.time = Rtime
        self.type = Rtype
        self.people = Rpeople
        self.ingredients = Ringredients
        self.method = Rmethod
        self.userId = RuserId
    }
    
    func toDictionary()->Any{
        return ["avtar":avtar, "name":name, "category":category, "time":time, "type":type, "people":people, "ingredients":ingredients, "method":method, "userId":userId] as Any
    }
}
