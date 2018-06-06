//
//  ContactsViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/30.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var sourceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
