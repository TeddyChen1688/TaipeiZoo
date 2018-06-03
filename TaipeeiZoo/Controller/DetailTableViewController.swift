//
//  DetailTableViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/31.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
// import ActionKit

class DetailTableViewController: UITableViewController {
    var article: Article!
 //   var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        //       downloadArticleImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            
            if let c = cell as? imageCell {
                if( article.imageHeight > 0){
                    c.imageHeight.constant = article.imageHeight
                    print("imageHeight is \(c.imageHeight.constant)")
                }
                c.nameLabel.text = article.name
                print("\(String(describing: c.nameLabel.text))")
                c.locationLabel.text = article.location
                
                let imageURL: URL?
                if let imageURLString = article.image_URLString {
                    imageURL = URL (string: imageURLString)
                }
                else {   imageURL = nil  }
                
                c.headerViewImage?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "traif.jpg"), options: .refreshCached)
            
                c.playVideo?.addControlEvent(.touchUpInside) {
                    let videoURL = URL(string: self.article.video_URLString!)
                    let player = AVPlayer(url: videoURL!)
                    let avpvv = AVPlayerViewController()
                    avpvv.player = player
                    self.present(avpvv, animated: true){
                    avpvv.player!.play()
                    }
                }
            }
            else {   print ("error to get cell back")    }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextCell_1.self), for: indexPath) as! TextCell_1

            cell.habitLabel.text = article.habit
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeatureCell_2.self), for: indexPath) as! FeatureCell_2
            cell.featureLabel.text = article.feature
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell_3.self), for: indexPath) as! DetailTextCell_3
            cell.dietLabel.text = article.diet
    
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapCell_4.self), for: indexPath) as! MapCell_4
            
            let lat = article.lat
            print("lat is \(lat)")
            let lng = article.lng
             print("lng is \(lng)")
            
            cell.configure(lat: lat, lng: lng)
            
            return cell
            
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMap" {
            let destinationController = segue.destination as! DetailMapViewController
            destinationController.article = article
        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showMap" {
//            let destinationController = segue.destination as! MapViewController
//            destinationController.restaurant = restaurant
//
//        } else if segue.identifier == "showReview" {
//            let destinationController = segue.destination as! ReviewViewController
//            destinationController.restaurant = restaurant
//        }
//    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func downloadArticleImage(){
    //        if let imageURL = article.image_URL {
    //            // let imageURL = article.image_URL
    //            print(article.image_URL)
    //            let session = URLSession.shared
    //            let task = session.dataTask(with: imageURL){ data, response, error in
    //                if let error = error {
    //                    print("fail")
    //                    return
    //                }
    //                let data = data!
    //                let image = UIImage(data: data)
    //                DispatchQueue.main.async {
    //                    self.headerView.headerImageView.image = image
    //                }
    //            }
    //            task.resume()
    //        }
    //    }
    

}
