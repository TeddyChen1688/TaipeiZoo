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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        // 2.1 根據規則:須先指定存取位置精度
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        

        
        
        //create a MapItem for destination
        let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = self.article.name
        
        let pointAnnotation = MKPointAnnotation()
        self.mapView.removeAnnotations(self.mapView.annotations) //把先前加的點先清除
        pointAnnotation.coordinate = destinationCoordinate
        
        pointAnnotation.title = self.article.location
        pointAnnotation.subtitle = self.article.name
        
        self.mapView.addAnnotation(pointAnnotation)
        
        let degree = self.distanceSlider.value * 1.0 / 111
        
        print("degree is \(degree)")
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: span)
        self.mapView.region = region
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        
        // 2.3 核心方法: 執行存取位置
        print("requestLocation")
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("on myLocationManager")
        
        let location = locations.first! // 何時指定 locations 的 dataType 是 [CLLocation] ?
            print("from viewController\(location)")
            let distance = self.distanceSlider.value

//          // create a MapItem for source
            let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
//
//            //create a MapItem for destination
            let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
            currentLocationMapItem.name = "出發點"
            destinationMapItem.name = self.article.location
            // 將起迄點放到陣列中
            let routes = [currentLocationMapItem, destinationMapItem]
        
    
           // 總結設定 MKDirectionRequest 的輸入參數:Source,destination,transportType
            let request = MKDirectionsRequest()
            request.source = currentLocationMapItem
            request.destination = destinationMapItem
            request.transportType = .walking

            let directions = MKDirections(request: request)

            directions.calculateETA(completionHandler: { response, error in
                if let error = error {
                   print("路徑規劃錯誤: \(error)")
                   return
                }
                let response = response!
                print("結果: \(response.expectedTravelTime / 60),\(response.distance)")
//
                let pointAnnotation = MKPointAnnotation()
                self.mapView.removeAnnotations(self.mapView.annotations) //把先前加的點先清除
                pointAnnotation.coordinate = destinationCoordinate
                
                pointAnnotation.title = self.article.location
                pointAnnotation.subtitle = self.article.name
//
                self.mapView.addAnnotation(pointAnnotation)     //加一個點在 map, 會一直加
                self.mapView.showsUserLocation = true // 顯示自己位置
//
               print("拉棒尺度：\(self.distanceSlider.value)")

                let degree = self.distanceSlider.value * 1.0 / 111
                
                print("degree is \(degree)")
                let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
                let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: span)
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
                
                // 設定為 walking 模式
                let options = [MKLaunchOptionsDirectionsModeKey:
                    MKLaunchOptionsDirectionsModeWalking]
                
                // 開啟地圖開始導航
                MKMapItem.openMaps(with: routes, launchOptions: options)

            })  // end of calculateETA
          } // end of request current location

    
    // 4. 錯誤就回報
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print("didFailWithError")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailMapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

//extension DetailMapViewController : MKMapViewDelegate {
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
//        if annotation is MKUserLocation {
//            //return nil so map view draws "blue dot" for standard user location
//            return nil
//        }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView?.pinTintColor = UIColor.orange
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: PointZero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "phone"), forState: .Normal)
//        button.addTarget(self, action: "getDirections", for: .TouchUpInside)
//        pinView?.leftCalloutAccessoryView = button
//        return pinView
//    }
//}
