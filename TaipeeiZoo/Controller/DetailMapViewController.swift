//
//  DetailMapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

// class DetailMapViewController: UIViewController{
   class DetailMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    var article: Article!
    var selectedPin:MKPlacemark? = nil
    
    var currentPlacemark: CLPlacemark?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceChangedLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var walkingTimeLabel: UILabel!
      @IBOutlet weak var mapView: MKMapView!

    @IBAction func distanceChanged(_ sender: Any) {
        let distance = round(distanceSlider.value * 100) / 100
        print("distance is \(distance)")
        distanceChangedLabel.text = "\(distance) km"
    }

    var request = MKDirectionsRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestLocation()
        //create a MapItem for destination
        let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = self.article.name
        dropPinZoomIn(placemark: destinationPlacemark)
    }
    
//    @IBAction func searchTapped(_ sender: Any) {
//        // 2.3 核心方法: 執行存取位置
//        locationManager.requestLocation()
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
            let distance = self.distanceSlider.value

//          // create a MapItem for source
            let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
            self.mapView.showsUserLocation = true // 顯示自己位置
//
//            //create a MapItem for destination
            let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
    
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            currentLocationMapItem.name = "出發點"
            print("current location is \(location)")
            destinationMapItem.name = self.article.location
            // 將起迄點放到陣列中
            let routes = [currentLocationMapItem, destinationMapItem]
           // print("current routes is \(routes)")
    
           // 總結設定 MKDirectionRequest 的輸入參數:Source,destination,transportType
            let request = MKDirectionsRequest()
            request.source = currentLocationMapItem
            request.destination = destinationMapItem
            request.transportType = .walking
            self.request = request

          } // end of request current location
    
    // 4. 錯誤就回報
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print("didFailWithError")
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
        let button = UIButton(type: .custom)
        button.frame  = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        button.setImage(UIImage(named: "taxi"), for: .normal)
        button.addTarget(self, action: #selector(DetailMapViewController.getDirections), for: UIControlEvents.touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    // the getDirections() method
    func getDirections(){
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMaps(launchOptions: launchOptions)
//        }
        print("Here is get direction")
        let request = self.request
        print("request is \(request)")
        let directions = MKDirections(request: request)
            directions.calculateETA(completionHandler: { response, error in
                if let error = error {
                    print("路徑規劃錯誤: \(error)")
                    return
                }
                let response = response!
                print("結果: \(response.expectedTravelTime / 60),\(response.distance)")
                let pointAnnotation = MKPointAnnotation()
                self.mapView.removeAnnotations(self.mapView.annotations) //把先前加的點先清除
                let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
                pointAnnotation.coordinate = destinationCoordinate
        
                pointAnnotation.title = self.article.location
                pointAnnotation.subtitle = self.article.name
                self.mapView.addAnnotation(pointAnnotation)     //加一個點在 map, 會一直加
                        
                self.mapView.showAnnotations([pointAnnotation], animated: true)
                self.mapView.selectAnnotation(pointAnnotation, animated: true)
        
                // 設定為 walking 模式
                let options = [MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeWalking]
        
                // 開啟地圖開始導航
                let routes = [request.source, request.destination]
                MKMapItem.openMaps(with: routes as! [MKMapItem], launchOptions: options)
        
                print("拉棒尺度：\(self.distanceSlider.value)")
        
                let degree = self.distanceSlider.value * 1.0 / 111
        
                print("degree is \(degree)")
                let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
                let region = MKCoordinateRegion(center: destinationCoordinate, span: span)
                self.mapView.region = region
                DispatchQueue.main.async {
                    self.storeDistanceLabel.text = "\(Int(response.distance)) m"
                    let walkTime = Int(response.expectedTravelTime / 60 )
                    self.walkingTimeLabel.text = "\(walkTime) min."
                    self.mapView.setCenter(pointAnnotation.coordinate, animated: true)
                }
        
                self.mapView.showsCompass = true
                self.mapView.showsTraffic = true
                self.mapView.showsScale = true
            })  // end of calculateETA

     }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        
        selectedPin = placemark
        // clear existing pins
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = self.article.location
        annotation.subtitle = self.article.name
        
        let degree = self.distanceSlider.value * 1.0 / 111
        
        self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        // self.mapView.region = region
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}








