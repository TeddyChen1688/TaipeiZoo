//
//  DetailViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var article: Article!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never
        
        headerView.nameLabel.text = article.name
        headerView.locationLabel.text = article.location
        headerView.headerImageView?.sd_setImage(with: article.image_URL)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell_0.self), for: indexPath) as! DetailTextCell_0
                    cell.habitLabel.text = article.habit
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell_1.self), for: indexPath) as! DetailTextCell_1
            cell.featureLabel.text = article.feature
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell_2.self), for: indexPath) as! DetailTextCell_2
            cell.dietLabel.text = article.diet
            print(cell.dietLabel.text)
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
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


