//
//  ArticleListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/8.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage         // To Optimize the Photo-download process
class ArticleListViewController: UITableViewController, UISearchBarDelegate{
// 由於下載是非同步事件, 若 tableViewdatasource 錯過了下載完成就不會更新畫面
// 因此強迫資料更新時(didSet), 要 tableViewdatasource 重新載入資料保證成功.
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var filtered = [Article]()
    
    var articles = [Article](){
        didSet{
            DispatchQueue.main.async{
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    var animalSectionTitles = [String]()
    var animalsDict = [String: [Article]]()
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        searchBar.delegate = self
        downLoadLatestArticles()
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // 定義旋轉指示器的佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // 啟用旋轉指示器
        spinner.startAnimating()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        navigationController?.hidesBarsOnSwipe = true
    }

    
    func downLoadLatestArticles(){
        Article.downLoadItem { (articles, error) in
            if let error = error {
                print("fail \(error)")
                return
            }
            let articles = articles!
               //  print(articles)
                
            articles.sorted(by: { $0.name_EN! < $1.name_EN! })
                
            var animalsDict = [String: [Article]]()
            var animalSectionTitles = [String]()
                
            for article in articles {
                // 取得動物名的第一個字母並建立字典
                // let firstLetterIndex = article.name_EN?.index((article.name_EN?.startIndex)!, offsetBy: 1)
               // let animalKey = article.name_EN![..<firstLetterIndex]
                let animalKey = String(article.name_EN!.first!)
                print("\(animalKey)")
                    
                if var animalValues = animalsDict[animalKey] {
                    animalValues.append(article)
                    animalsDict[animalKey] = animalValues
                } else {
                    animalsDict[animalKey] = [article]
                }
                
            }
            
            animalSectionTitles = [String](animalsDict.keys)
            animalSectionTitles = animalSectionTitles.sorted(by: { $0 < $1 })
            
            print("==================================================")
            print("animalSectionTitles --   \(animalSectionTitles)")
            print("==================================================")
            print("animalsDict --   \(animalsDict)")
            self.animalSectionTitles = animalSectionTitles
            self.animalsDict = animalsDict
            self.articles = articles
            
            self.refreshControl?.endRefreshing()
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            print("search");
            searchActive = false
        }else{
            print("searchText");
            filtered = articles.filter ({ (article_f) -> Bool in
                let tmp: String = article_f.name
                let range = tmp.range(of:searchText, options: String.CompareOptions.caseInsensitive)
                return range != nil
            })
        
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
         //   self.view.endEditing(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 回傳區塊的總數
        if searchActive == true {
            return 0
        }
        else {
        return animalSectionTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive == true {
            return "Find"
        }
        else {
        return animalSectionTitles[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        print (" article.count is \(articles.count)")
        
        let animalKey = animalSectionTitles[section]
        guard let animalValues = animalsDict[animalKey] else {
            return 0
        }
        return animalValues.count
       // return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        
        var article : Article
        if(searchActive){   article = filtered[indexPath.row]   }
        else{
            article = articles[indexPath.row]
            let animalKey = animalSectionTitles[indexPath.section]
            if let animalValues = animalsDict[animalKey] {
            article = animalValues[indexPath.row]
            }
        
            let imageURL: URL?
            if let imageURLString = article.Pic01_URLString {
                imageURL = URL (string: imageURLString)
            }
            else {  imageURL = nil   }
        
            if let c = cell as? ListTableCell {
            
                c.photoView?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "traif.jpg"), options: .refreshCached) {(img, err, cachetype, url) in
                
                    let screenWidth:CGFloat = UIScreen.main.bounds.width
                    if let width = img?.size.width , let height = img?.size.height {
                        self.articles[indexPath.row].imageHeight = screenWidth / width * height
                    }
                }
                print("id is \(article.id)");
                c.idLabel.text = article.id;
                c.nameLabel?.text = article.name;
                print("\(article.name)");
                c.name_ENLabel?.text = article.name_EN
                c.locationLabel?.text = article.location
            
                var geo = article.geo
                print("Geo is \(geo)")
                let geo_StringA = geo?.split(separator: "(", maxSplits: 3)[1]
                let geo_StringB = geo_StringA?.split(separator: ")", maxSplits: 3)[0]
                let geo_array = geo_StringB?.split(separator: " ", maxSplits: 3)
                let lng_String = String((geo_array?.first!)!) as NSString
                let lng = lng_String.doubleValue
                self.articles[indexPath.row].lng = lng
                print("lng is \(lng)")
                let lat_String = String((geo_array?.last!)!) as NSString
                let lat = lat_String.doubleValue
                self.articles[indexPath.row].lat = lat
                print("lat is \(lat)")
            }
        }
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return animalSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        headerView.textLabel?.textColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail"{
            print("翻頁了...")
            let cell = sender as! UITableViewCell
            let detailVC = segue.destination as! DetailTableViewController
            let indexPath = tableView.indexPath(for: cell)!
            
        //    let article = articles[indexPath.row]
            var article : Article
            
            if(searchActive){
                article = filtered[indexPath.row]
            }
            else{
                article = articles[indexPath.row]
            }
            
            detailVC.article = article
            print(article)
        }
    }

}
