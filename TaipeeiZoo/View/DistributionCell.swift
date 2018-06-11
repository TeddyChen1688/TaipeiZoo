//
//  DistributionCell.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/11.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class DistributionCell: UITableViewCell {

    @IBOutlet weak var distributionLabel: UILabel!{
        didSet {
            distributionLabel.numberOfLines = 0
        }
    }
}
