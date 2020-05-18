//
//  ViewController.swift
//  CookingApp
//
//  Created by Raju Gupta on 17/04/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: DesignableLetterSpacing!
    @IBOutlet weak var btnLogin: DesignableButton!
    @IBOutlet weak var btnSignUp: DesignableButton!
    @IBOutlet weak var lblNewAccountText: DesignableLetterSpacing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        AnimationSetUp()
    }
    
    func UISetUp(){
        lblTitle.alpha = 0
        btnLogin.alpha = 0
        btnSignUp.alpha = 0
        lblNewAccountText.alpha = 0
    }
    //MARK: - Animation 
    func AnimationSetUp(){
        UIView.animate(withDuration: 1, animations: {
            self.lblTitle.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.btnLogin.alpha = 1
                self.btnSignUp.alpha = 1
                self.lblNewAccountText.alpha = 1
                self.snowAnimation()
            })
        }
    }
    
    func snowAnimation(){
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "food"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        self.view.layer.addSublayer(emitter)
    }
    
}

