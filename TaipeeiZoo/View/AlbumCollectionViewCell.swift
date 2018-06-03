//
//  AlbumCollectionViewCell.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

//import UIKit
//
//protocol AlbumCollectionCellDelegate {
//    func didLikeButtonPressed(cell: AlbumCollectionViewCell)
//}
//
//
//class AlbumCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var likeButton: UIButton!
//
//    var delegate: AlbumCollectionCellDelegate?
//
//    var isLiked:Bool = false  {
//        didSet {
//            if isLiked {
//                likeButton.setImage(UIImage(named: "heartfull"), for: .normal)
//            } else {
//                likeButton.setImage(UIImage(named: "heart"), for: .normal)
//            }
//        }
//    }
//
//    @IBAction func likeButtonTapped(sender: AnyObject) {
//        delegate?.didLikeButtonPressed(cell: self)
//    }
//}
