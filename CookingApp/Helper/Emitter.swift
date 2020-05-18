//
//  Emitter.swift
//  CookingApp
//
//  Created by Raju Gupta on 29/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class Emitter{
    static func get(with image : UIImage) -> CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterCells = generateEmitterCell(with: image)
        return emitter
    }
    
    static func generateEmitterCell(with image : UIImage) -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 1
        cell.lifetime = 50
        cell.velocity = 25
        cell.emissionLongitude = (180 * (.pi/180))
        cell.emissionRange = (45 * (.pi/180))
        cell.scale = 0.05
        cell.scaleRange = 0.1
        
        cells.append(cell)
        
        return cells
    }
}
