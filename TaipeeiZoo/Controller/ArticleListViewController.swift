//
//  ArticleListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/8.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class ArticleListViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating{
    
    var filtered = [Article]()
    var articles = [Article]()
    var animalSectionTitles = [String]()
    var animalsDict = [String: [Article]]()
    var locationKeys = [String]()
    var locationDict = [String: [Article]]()
    var searchController: UISearchController!
    var searchResults: [Article] = []
    
//    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
//        dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
  
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .always
        navigationController?.hidesBarsOnSwipe = false
        
        // Adding a search controller
        searchController = UISearchController(searchResultsController: nil)
        // self.navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "寫下寶貝的中文/英文名來找尋....."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        tableView.tableHeaderView = searchController.searchBar
    }
    
//    func back(sender: UIBarButtonItem){
//        print("返回")
//    }
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.hidesBarsOnSwipe = false
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return 1
        } else {
            return animalSectionTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive{
            return ""
        }
        else {
            return animalSectionTitles[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            let animalKey = animalSectionTitles[section]
            guard let animalValues = animalsDict[animalKey] else {
                return 0
            }
           // print("animalValues.count is \(animalValues.count)")
            return animalValues.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        var article : Article
        let animalKey = animalSectionTitles[indexPath.section]
        let animalValues = animalsDict[animalKey]
        article = (searchController.isActive) ? searchResults[indexPath.row] : animalValues![indexPath.row]
        // print("indexPath.row is \(indexPath.row)")
        let imageURL: URL?
        if let imageURLString = article.Pic01_URLString {
            imageURL = URL (string: imageURLString)
        }
        else {  imageURL = nil   }
        
        let c = cell // as? ListTableCell {
        do {
            c.photoView?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "tree.jpg"), options: .refreshCached) {(img, err, cachetype, url) in
                
                let screenWidth:CGFloat = UIScreen.main.bounds.width
                if let width = img?.size.width , let height = img?.size.height {
                    self.articles[indexPath.row].imageHeight = 1.2 * screenWidth / width * height
                }
            }
       //    c.idLabel.text = article.id;
            c.nameLabel?.text = article.name;
            print("\(String(describing: article.name))");
            c.name_ENLabel?.text = article.name_EN
            c.locationLabel?.text = article.location
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {  return false
        }else {    return true         }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        
        return animalSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 0.5)
        headerView.textLabel?.textColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        headerView.textLabel?.font = UIFont(name: "Rubik", size: 25.0)
    }
    
    func filterContent(for searchText: String) {
        searchResults = articles.filter({ (article) -> Bool in
            if let name = article.name, let name_EN = article.name_EN {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || name_EN.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            print("翻頁了...")
            let cell = sender as! UITableViewCell
            let detailVC = segue.destination as! DetailTableViewController
            let indexPath = tableView.indexPath(for: cell)!
            var article : Article
            if searchController.isActive {
                article = searchResults[indexPath.row]
            }
            else{
                let animalKey = animalSectionTitles[indexPath.section]
                let animalValues = animalsDict[animalKey]
                article = animalValues![indexPath.row]
            }
            detailVC.article = article
        //    print(article)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
