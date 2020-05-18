//
//  Extension.swift
//  CookingApp
//
//  Created by Raju Gupta on 03/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit
import JTMaterialSpinner

extension UIViewController{
    
    // MARK: - Custom Pop Up Set Up
    func showAlert(title: String, subTitle : String, isOKBtnHidden : Bool){
        let storyboard = UIStoryboard(name: "Reusable", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PopUpViewController") as! PopUpViewController
        
        PopUpAttribute.share.attributes.removeAll()
        PopUpAttribute.share.attributes.append(Popup(title: title, subTitle: subTitle, btnEnable: isOKBtnHidden))
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Loader or Spinner set up
    func spinnerSetUp(spinnerView:JTMaterialSpinner){
        self.view.addSubview(spinnerView)
        spinnerView.frame.size.width = 50
        spinnerView.frame.size.height = 50
        spinnerView.center = view.center
        spinnerView.circleLayer.lineWidth = 5.0
        spinnerView.circleLayer.strokeColor = #colorLiteral(red: 0.8097097011, green: 0.5250776736, blue: 0.8705882353, alpha: 1)
        
    }
    
    
    // MARK: - Adding DropDown List downSide function
    func addDropDown(elements : [String], btn: UIButton, viewContainer:UIView){
        let storyboard = UIStoryboard(name: "Reusable", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DropDown") as! DropDown
        vc.btn = btn
        vc.elements = elements
        addChild(vc)
        viewContainer.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.addDropDownList()
    }
    
    // MARK: - Adding DropDown List upSide function
    func addDropDownUpSide(elements : [String], btn: UIButton, viewContainer:UIView){
        let storyboard = UIStoryboard(name: "Reusable", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DropDown") as! DropDown
        vc.btn = btn
        vc.elements = elements
        addChild(vc)
        viewContainer.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.addDropDownListUpSide()
    }
}


//MARK: - Hex String to Color Converstion
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


