//
//  ListTableCell.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!{
        didSet {
            photoView.layer.cornerRadius = 40
            photoView.clipsToBounds = true
        }
    }
    
    
   @IBOutlet weak var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var name_ENLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

}
