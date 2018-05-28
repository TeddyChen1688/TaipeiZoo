//
//  ArticleListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/8.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

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
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        searchBar.delegate = self
        downLoadLatestArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func downLoadLatestArticles(){
        Article.downLoadItem { (articles, error) in
            if let error = error {
                print("fail \(error)")
                return
            }
            if let articles = articles {
                self.articles = articles
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
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
        
        if(searchText == " "){
            searchActive = false
        }else{
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
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        
        var article : Article
        
        if(searchActive){
            article = filtered[indexPath.row]
        }
        else{
            article = articles[indexPath.row]
        }
        
        cell.nameLabel?.text = article.name
        cell.name_ENLabel?.text = article.name_EN
        print("\(article.name)")
        cell.locationLabel?.text = article.location
       // cell.photoView?.sd_setImage(with: article.image_URL)
        
        cell.photoView.sd_setImage(with: article.image_URL, placeholderImage: UIImage(named: "traif.jpg"), options: .refreshCached)
       //.sd_setImage(with: URL(string: objUserData.back_image!), placeholderImage:UIImage(named: "cardBack"), options: .refreshCached)
        return cell
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            print("翻頁了...")
            let cell = sender as! UITableViewCell
            let detailVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPath(for: cell)!
            let article = articles[indexPath.row]
            detailVC.article = article
        }
    }

}
