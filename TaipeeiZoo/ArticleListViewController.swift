//
//  ArticleListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/8.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController {
// 由於下載是非同步事件, 若 tableViewdatasource 錯過了下載完成就不會更新畫面
// 因此強迫資料更新時(didSet), 要 tableViewdatasource 重新載入資料保證成功.
    var articles = [Article](){
        didSet{
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downLoadLatestArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func downLoadLatestArticles(){
        Article.downLoadItem { (articles, error) in
            if let error = error {
                print("下載失敗了 \(error)")
                return
            }
            if let articles = articles {
                // self 專指本 class 的屬性
                self.articles = articles
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(articles.count)")
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let article = articles[indexPath.row]
        print("\(article.name)")
        cell.textLabel?.text = article.name
        cell.detailTextLabel?.text = article.location
        

        // Configure the cell...

        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showArticleDetail"{
//            print("翻頁了...")
//            let cell = sender as! UITableViewCell
//            let detailVC = segue.destination as! ArticleDetailViewController
//            let indexPath = tableView.indexPath(for: cell)!
//            let article = articles[indexPath.row]
//            detailVC.article = article
//        }
//    }
 
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
