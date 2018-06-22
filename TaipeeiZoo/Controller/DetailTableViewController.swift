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
import SafariServices
import MapKit

class DetailTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var article: Article!
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    @IBOutlet weak var headerView: ArticleDetailHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        UITableView.appearance().contentInsetAdjustmentBehavior = .never
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
        // Configure header view
        headerView.nameLabel.text = article.name
        let imageURL: URL?
        if let imageURLString = article.Pic02_URLString {
                imageURL = URL (string: imageURLString)
                }
        else {   imageURL = nil  }
        headerView.headerViewImage?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "tree.jpg"), options: .refreshCached)

        headerView.playVideo?.addControlEvent(.touchUpInside) {
            if let video_Url = URL(string: self.article.video_URLString!) {
                                print("button click with VideoURL \(video_Url)")
            let safariController = SFSafariViewController(url: video_Url)
                self.present(safariController, animated: true, completion: nil)
                }
            }

        headerView.chkVideoImageView.isHidden = article.chk_video ? false : true
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//       navigationItem.largeTitleDisplayMode = .always
 //     tableView.contentInsetAdjustmentBehavior = .never
        
        // 2.1.4 導覽列取透明
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        // 2.1.5 變更導覽列項目（像是返回按鈕與標題）的顏色
    //    navigationController?.navigationBar.tintColor = .gray
        //  true - 滑動表格視圖內容時,會隱藏導覽列,滑一滑就不見了
        //  false - 不會隱藏導覽列,再怎麼滑都在
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // "viewwillAppear" control the outlook of pop-forward and back
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = false
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.tintColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        
        // Hide the back left button when setting "true"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // "viewwillAppear" control the outlook of pop-forward and back
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
        UITableView.appearance().contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        print("viewWillDisappear shadowImage = nil")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func playUsingAVPlayer(url: URL) {
            player = AVPlayer(url: url)
            player?.play()
        }
        switch indexPath.row {
            
 //       case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
//            if let c = cell as? imageCell {
//                if( article.imageHeight > 0){
//                    c.imageHeight.constant = article.imageHeight
//                    print("imageHeight is \(c.imageHeight.constant)")
//                }
//                c.nameLabel.text = article.name
//                print("\(String(describing: c.nameLabel.text))")
//          //      c.locationLabel.text = article.location
//
//                let imageURL: URL?
//                if let imageURLString = article.Pic02_URLString {
//                    imageURL = URL (string: imageURLString)
//                }
//                else {   imageURL = nil  }
//
//                c.headerViewImage?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "tree.jpg"), options: .refreshCached)
//
//                c.playVideo?.addControlEvent(.touchUpInside) {
//                    if let video_Url = URL(string: self.article.video_URLString!) {
//                        print("button click with VideoURL \(video_Url)")
//                        let safariController = SFSafariViewController(url: video_Url)
//                        self.present(safariController, animated: true, completion: nil)
//                    }
//                }
//                c.chkVideoImageView.isHidden = article.chk_video ? false : true
//
//               //  cell.heartImageView.isHidden = favorites[indexPath.row].isVisited ? false : true
//            }
//            else {   print ("error to get cell back")   }
//            return cell
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextCell_1.self), for: indexPath) as! TextCell_1
            cell.habitLabel.text = article.habit
            print("cell.habitLabel.text \(String(describing: cell.habitLabel.text))")
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DistributionCell.self), for: indexPath) as! DistributionCell
            cell.distributionLabel.text = article.distribution
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeatureCell_2.self), for: indexPath) as! FeatureCell_2
            cell.featureLabel.text = article.feature
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BehaviorCell.self), for: indexPath) as! BehaviorCell
            cell.behaviorLabel.text = article.behavior
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell_3.self), for: indexPath) as! DetailTextCell_3
            cell.dietLabel.text = article.diet
            return cell

        case 5:
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//===================================================================
//                c.playSoundButton.addControlEvent(.touchUpInside, {
//                    guard let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")else {
//                        print("Invalid URL")
//                        return
//                        }
//                    print("button click with AuduioURL \(url)")
//                    self.tableView.reloadData()
//
//                    self.playerItem = AVPlayerItem(url: url)
//                    let playerItem = self.playerItem!
//                    let player = AVPlayer(playerItem: playerItem)
//
//                    let playerLayer = AVPlayerLayer(player: player)
//                    playerLayer.frame  = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
//                    self.view.layer.addSublayer(playerLayer)
//
//                    if  player.rate == 0 {
//                        player.play()
//                        print("=============== Now Play with  player.rate \(player.rate)")
//                        c.playSoundButton.setImage(UIImage(named: "pause"), for: .normal)
//                    }else{
//                        c.playSoundButton.setImage(UIImage(named: "music"), for: .normal)
//                                // playUsingAVPlayer(url:url )
//                        player.pause()
//                        print("=============== Now pause")
//                    }
//                })
//=========================================================
