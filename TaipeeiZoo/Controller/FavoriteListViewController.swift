//
//  FavoriteListViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/1.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//
// Update at 11:12

import UIKit
import CoreData

class FavoriteListViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    // MARK: - Properties
    var favorites: [FavoriteMO] = []
    var fetchResultController: NSFetchedResultsController<FavoriteMO>!
    @IBOutlet var emptyRestaurantView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
 //       tableView.rowHeight = UITableViewAutomaticDimension
 //       tableView.estimatedRowHeight = 100
//
//        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
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
                    favorites = favorites.sorted(by: { $0.postDate > $1.postDate })
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
        cell.nameLabel.text = favorites[indexPath.row].name
        if let favoritesImage = favorites[indexPath.row].image {
            cell.thumbnailImageView.image = UIImage(data: favoritesImage as Data)
            cell.thumbnailImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        }
        let storedDate = favorites[indexPath.row].postDate
        print("storedDate is \(storedDate)")
        let publishedDate = Date(timeIntervalSince1970: storedDate / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: publishedDate)
        cell.summaryLabel.text = favorites[indexPath.row].summary
        print("cell.summaryLabel.text is \(String(describing: cell.summaryLabel.text))")
        cell.heartImageView.isHidden = favorites[indexPath.row].isVisited ? false : true
        return cell
    }
   
    // MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data store
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "在台北動物園的我,和我最愛的:" + self.favorites[indexPath.row].name!
            let activityController: UIActivityViewController
            
            if let favoriteImage = self.favorites[indexPath.row].image,
                let imageToShare = UIImage(data: favoriteImage as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else  {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        // Customize the action buttons
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")
        shareAction.backgroundColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! FavoriteCell
            self.favorites[indexPath.row].isVisited = (self.favorites[indexPath.row].isVisited) ? false : true
            cell.heartImageView.isHidden = self.favorites[indexPath.row].isVisited ? false : true
            completionHandler(true)
        }
        
        // Customize the action button
        checkInAction.backgroundColor = UIColor(red: 39, green: 174, blue: 96)
        checkInAction.image = self.favorites[indexPath.row].isVisited ? UIImage(named: "undo") : UIImage(named: "tick")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        return swipeConfiguration
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            favorites = fetchedObjects as! [FavoriteMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
