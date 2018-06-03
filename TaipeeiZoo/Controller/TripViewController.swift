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

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var favorites: [FavoriteMO] = []
    @IBOutlet var emptyRestaurantView: UIView!
    
    var fetchResultController: NSFetchedResultsController<FavoriteMO>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        collectionView.backgroundColor = UIColor.clear
        
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
        }
        
        
   // Fetch data from data store
        let fetchRequest: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            DispatchQueue.main.async{
                // self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    favorites = fetchedObjects
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
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
        }
    }
}


//    public var trips = [Trip(tripId: "Paris001", city: "Paris", featuredImage: UIImage(named: "paris"), isLiked: false),
//                         Trip(tripId: "Rome001", city: "Rome",  featuredImage: UIImage(named: "rome"),  isLiked: false),
//                         Trip(tripId: "Istanbul001", city: "Istanbul", featuredImage: UIImage(named: "istanbul"),  isLiked: false),
//                         Trip(tripId: "London001", city: "London",  featuredImage: UIImage(named: "london"),  isLiked: false),
//                         Trip(tripId: "Sydney001", city: "Sydney", featuredImage: UIImage(named: "sydney"), isLiked: false),
//                         Trip(tripId: "Santorini001", city: "Santorini", featuredImage: UIImage(named: "santorini"), isLiked: false),
//                         Trip(tripId: "NewYork001", city: "New York",  featuredImage: UIImage(named: "newyork"), isLiked: false),
//                         Trip(tripId: "Kyoto001", city: "Kyoto",  featuredImage: UIImage(named: "kyoto"), isLiked: false)
//    ]
