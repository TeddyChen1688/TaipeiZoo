//
//  DetailTextCell_1.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class FeatureCell_2: UITableViewCell {
    
    
    @IBOutlet weak var featureLabel: UILabel!{
        didSet {
            featureLabel.numberOfLines = 0
        }
    }

}
