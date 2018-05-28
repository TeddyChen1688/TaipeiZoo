//
//  ArticleDetailViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/8.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    var article: Article!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .blue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0) ]
        
        
       //  UItableview.contentInsetAdjustmentBehavior = .never
        
        nameLabel.text = article.name
        locationLabel.text = article.location
        habitLabel.text = article.habit
        featureLabel.text = article.feature
        dietLabel.text = article.diet

        downloadArticleImage()
    }
    
    func downloadArticleImage(){
        if let imageURL = article.image_URL {
           // let imageURL = article.image_URL
            print(article.image_URL)
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL){ data, response, error in
                if let error = error {
                    print("fail")
                    return
                }
                let data = data!
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            task.resume()
        }
    }
}
