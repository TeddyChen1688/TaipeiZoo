//
//  TripViewController.swift
//  TripCard
//
//  Created by Simon Ng on 8/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class TripViewController: UIViewController, NSFetchedResultsControllerDelegate{

    var favorites: [FavoriteMO] = []
    var favorite: FavoriteMO!
    var fetchResultController: NSFetchedResultsController<FavoriteMO>!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyRestaurantView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "tree")
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        collectionView.backgroundColor = UIColor.clear
        navigationController?.hidesBarsOnSwipe = true
        
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
        }
        // Fetch data from data store
        fetchDataFmDataStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        if UserDefaults.standard.bool(forKey: "hasSaveNewUserDataToDataStore") {
            fetchDataFmDataStore()
        }
        UserDefaults.standard.set(false, forKey: "hasSaveNewUserDataToDataStore")
            dismiss(animated: true, completion: nil)
    }
    
    
    func fetchDataFmDataStore(){
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
                    self.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}

extension TripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("favorites.count is \(favorites.count)")
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionViewCell
        
        // Configure the cell
        cell.cityLabel.text = favorites[indexPath.row].name
        
        if let favoritesImage = favorites[indexPath.row].image {
            
            cell.imageView.image = UIImage(data: favoritesImage as Data)

        }
        cell.isLiked = favorites[indexPath.row].isVisited
        cell.delegate = self
        
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        return cell
    }
}

extension TripViewController: TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            favorites[indexPath.row].isVisited = favorites[indexPath.row].isVisited ? false : true
            cell.isLiked = favorites[indexPath.row].isVisited
            // Saving  to database
//            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//                favorite = FavoriteMO(context: appDelegate.persistentContainer.viewContext)
//            // print("Saving data to context ...")
//                appDelegate.saveContext()
//            }
        }
    }
}



