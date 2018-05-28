//
//  DetailTextCell_0.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class DetailTextCell_0: UITableViewCell {
    
    @IBOutlet var habitLabel: UILabel! {
        didSet {
            habitLabel.numberOfLines = 0
        }
    }

}
