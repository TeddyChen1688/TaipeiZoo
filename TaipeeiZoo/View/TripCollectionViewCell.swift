//
//  TripCollectionViewCell.swift
//  TripCard
//
//  Created by Simon Ng on 25/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

protocol TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionViewCell)
}

class TripCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var delegate:TripCollectionCellDelegate?
    
    var isLiked:Bool = false  {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage(named: "heartfull"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "heart"), for: .normal)
            }
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        delegate?.didLikeButtonPressed(cell: self)
    }
}
