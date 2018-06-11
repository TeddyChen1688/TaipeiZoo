//
//  BehaviorCell.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/11.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class BehaviorCell: UITableViewCell {

    @IBOutlet weak var behaviorLabel: UILabel!{
        didSet {
            behaviorLabel.numberOfLines = 0
        }
    }
}
