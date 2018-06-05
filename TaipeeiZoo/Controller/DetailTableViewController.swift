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

class DetailTableViewController: UITableViewController {
    var article: Article!
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
       navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.largeTitleDisplayMode = .always
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
        
        func playUsingAVPlayer(url: URL) {
            player = AVPlayer(url: url)
            player?.play()
        }
        
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
          //      c.locationLabel.text = article.location
                
                let imageURL: URL?
                if let imageURLString = article.Pic02_URLString {
                    imageURL = URL (string: imageURLString)
                }
                else {   imageURL = nil  }
                
                c.headerViewImage?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "tree.jpg"), options: .refreshCached)
            
                c.playVideo?.addControlEvent(.touchUpInside) {
                    let videoURL = URL(string: self.article.video_URLString!)
                    print("videoURL \(videoURL)")
                    UIApplication.shared.open(videoURL!, options: [:], completionHandler: nil)
                    
//                    let player = AVPlayer(url: videoURL!)
//                    let avpvv = AVPlayerViewController()
//                    avpvv.player = player
//                    self.present(avpvv, animated: true){
//                    avpvv.player!.play()
//                    }
                }
                c.playSoundButton.addControlEvent(.touchUpInside, {
                    print("button click")
                    self.tableView.reloadData()
                    guard let url = URL(string: self.article.Voice01_URLString!  ) else {
                        print("Invalid URL")
                        return
                    }
                    print("AuduioURL \(url)")
                    if let myplayer = self.player{
                        if ((myplayer.rate != 0) && (myplayer.error == nil)) {
                            myplayer.pause()
                            c.playSoundButton.setImage(UIImage(named: "music"), for: .normal)
                        }else{
                            c.playSoundButton.setImage(UIImage(named: "pause"), for: .normal)
                            playUsingAVPlayer(url:url )
                        }
                    }else{
                        c.playSoundButton.setImage(UIImage(named: "pause"), for: .normal)
                        playUsingAVPlayer(url:url )
                    }
                })
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
    
            cell.configure(lat: article.lat, lng: article.lng, location: article.location!)
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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
