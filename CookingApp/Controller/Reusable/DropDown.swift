//
//  ViewController2.swift
//  DropDown
//
//  Created by Raju Gupta on 01/05/20.
//  Copyright © 2020 Raju Gupta. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class DropDown: UIViewController {
    
    var elements = [String]()
    var btn : UIButton!
    @IBOutlet weak var dropdownTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dropdownTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        dropdownTableView.separatorStyle = .none
    }
    @IBAction func onClickViewDismissBtn(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func addDropDownList() {
        let frames = btn.frame
        dropdownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(elements.count * 50))
        self.view.addSubview(dropdownTableView)
        dropdownTableView.layer.cornerRadius = 5
    }
    func addDropDownListUpSide() {
        let frames = btn.frame
        dropdownTableView.frame = CGRect(x: frames.origin.x, y: (frames.origin.y - 5) - CGFloat(elements.count * 50), width: frames.width, height: CGFloat(elements.count * 50))
        self.view.addSubview(dropdownTableView)
        dropdownTableView.layer.cornerRadius = 5
    }
}

extension DropDown: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = elements[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btn.setTitle(elements[indexPath.row], for: .normal)
        let frames = btn.frame
        dropdownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: CGFloat(elements.count * 0))
        self.view.removeFromSuperview()
        
    }
}
