//
//  DetailTextCell_1.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class DetailTextCell_3: UITableViewCell {
    
    @IBOutlet weak var dietLabel: UILabel!{
        didSet {
            dietLabel.numberOfLines = 0
        }
    }

}
