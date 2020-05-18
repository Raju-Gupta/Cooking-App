//
//  DataConvertion.swift
//  CookingApp
//
//  Created by Raju Gupta on 13/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class DataConvertion{
    
    static func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    static func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    static func newAttrSize(blockQuote: NSAttributedString) -> NSAttributedString
    {
        let yourAttrStr = NSMutableAttributedString(attributedString: blockQuote)
        yourAttrStr.enumerateAttribute(.font, in: NSMakeRange(0, yourAttrStr.length), options: .init(rawValue: 0)) {
            (value, range, stop) in
            if var font = value as? UIFont {
                font = UIFont.systemFont(ofSize: 18)
                let resizedFont = font.withSize(font.pointSize * 1)
                yourAttrStr.addAttribute(.font, value: resizedFont, range: range)
            }
        }
        return yourAttrStr
    }
    
}
//MARK: - HTML to String Convertion
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

