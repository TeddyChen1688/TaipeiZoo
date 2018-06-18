//
//  DetailMapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit

   class DetailMapViewController: UIViewController,  MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var article: Article!
    var destinationPlacemark: MKPlacemark?
    let myLocationManager = MyLocationManager()
    var request = MKDirectionsRequest()
    let degree = 1.0 / 111

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.title = "走,去看寶貝!"

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.tintColor = .blue
        
        
        let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        self.destinationPlacemark = destinationPlacemark
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationPlacemark.coordinate
        destinationAnnotation.title = self.article.location
        destinationAnnotation.subtitle = self.article.name
        self.mapView.setCenter(destinationPlacemark.coordinate, animated: true)
        dropPinZoomIn(placemark: destinationPlacemark, annotation: destinationAnnotation )
        
        myLocationManager.requestLocation(completionHandler: { location in
            // create MapItems for source and destination
            let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
            self.mapView.showsUserLocation = true // 顯示自己位置
            let destinationMapItem = MKMapItem(placemark: self.destinationPlacemark!)
            currentLocationMapItem.name = "出發點"
            destinationMapItem.name = self.article.location
            // 將起迄點 MapItem 放到陣列中
            let routes = [currentLocationMapItem, destinationMapItem]
            let request = MKDirectionsRequest()
            request.source = currentLocationMapItem
            request.destination = destinationMapItem
            request.transportType = .walking
            self.request = request
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
       // navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 0.1)
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        // pinView?.backgroundColor =  UIColor(red: 0.208, green:0.596 , blue: 0.859, alpha: 1);
        let button = UIButton(type: .custom)
        button.frame  = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
       //  button.backgroundColor = UIColor(red: 0.208, green:0.596 , blue: 0.859, alpha: 1)
        button.setImage(UIImage(named: "walker"), for: .normal)
        button.addTarget(self, action: #selector(DetailMapViewController.getDirections), for: UIControlEvents.touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        pinView?.animatesDrop = true
        return pinView
    }
    
    func getDirections(){
        let directions = MKDirections(request: self.request)
            directions.calculateETA(completionHandler: { response, error in
                if let error = error {
                    print("路徑規劃錯誤: \(error)")
                    return
                }
                let response = response!
                let options = [MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeWalking]
                // 開啟地圖開始導航
                let routes = [self.request.source, self.request.destination]
                MKMapItem.openMaps(with: routes as! [MKMapItem], launchOptions: options)
                self.mapView.showsCompass = true
                self.mapView.showsScale = true
            })  // end of get Direction
     }
    
    func dropPinZoomIn(placemark:MKPlacemark, annotation: MKAnnotation){
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
      //  self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(self.degree), longitudeDelta: CLLocationDegrees(self.degree))
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}








