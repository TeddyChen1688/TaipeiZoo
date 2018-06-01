//
//  FavoriteListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/1.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    // MARK: - Properties
    
    var favorites: [FavoriteMO] = []
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    var fetchResultController: NSFetchedResultsController<FavoriteMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
//
//
//        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

         navigationController?.hidesBarsOnSwipe = true
//
//        // Prepare the empty view
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
//
//        // Fetch data from data store
        let fetchRequest: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    favorites = fetchedObjects
                }
            } catch {
                print(error)
            }
        }

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource Protocol

    override func numberOfSections(in tableView: UITableView) -> Int {
        if favorites.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...

        let cellIdentifier = "FavoriteCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteCell
        
        // Configure the cell...
        cell.nameLabel.text = favorites[indexPath.row].name
        if let favoritesImage = favorites[indexPath.row].image {
            cell.thumbnailImageView.image = UIImage(data: favoritesImage as Data)
        }

        cell.heartImageView.isHidden = favorites[indexPath.row].isVisited ? false : true
        
        return cell
    }
   

 

}
