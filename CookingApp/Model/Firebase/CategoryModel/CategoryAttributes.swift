//
//  CategoryAttributes.swift
//  CookingApp
//
//  Created by Raju Gupta on 14/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class CategoryAttributes{
    let avtar : String
    let name : String
    let color : String
    
    init(Cavtar:String, Cname:String, Ccolor:String){
        self.avtar = Cavtar
        self.name = Cname
        self.color = Ccolor
    }
    
    func toDictionary()->Any{
        return ["avtar": avtar, "name": name, "color": color] as Any
    }
}
