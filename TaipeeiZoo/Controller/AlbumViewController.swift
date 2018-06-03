//
//  AlbumViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
//    @IBOutlet var backgroundImageView: UIImageView!
//    @IBOutlet var collectionView: UICollectionView!
//
//    var favorite: FavoriteMO!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Apply blurring effect
//        backgroundImageView.image = UIImage(named: "cloud")
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        backgroundImageView.addSubview(blurEffectView)
//
//        collectionView.backgroundColor = UIColor.clear
//
//        if UIScreen.main.bounds.size.height == 568.0 {
//            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
//        }
//
//        // Configure navigation bar appearance
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.shadowImage = UIImage()
////
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//}
//
//extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return favorite.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionViewCell
//
//        // Configure the cell
//        cell.cityLabel.text = trips[indexPath.row].city
//        cell.countryLabel.text = trips[indexPath.row].country
//        cell.imageView.image = trips[indexPath.row].featuredImage
//        cell.priceLabel.text = "$\(String(trips[indexPath.row].price))"
//        cell.totalDaysLabel.text = "\(trips[indexPath.row].totalDays) days"
//        cell.isLiked = trips[indexPath.row].isLiked
//        cell.delegate = self
//
//        // Apply round corner
//        cell.layer.cornerRadius = 4.0
//
//        return cell
//    }
}

//extension AlbumViewController: TripCollectionCellDelegate {
//    func didLikeButtonPressed(cell: TripCollectionViewCell) {
//        if let indexPath = collectionView.indexPath(for: cell) {
//            trips[indexPath.row].isLiked = trips[indexPath.row].isLiked ? false : true
//            cell.isLiked = trips[indexPath.row].isLiked
//        }
//    }
//}
