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
    var article: Article!
    var destinationPlacemark: MKPlacemark?
    let myLocationManager = MyLocationManager()
    
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
        mapView.delegate = self
        
        let destinationCoordinate = CLLocationCoordinate2D(latitude: self.article.lat, longitude: self.article.lng)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        self.destinationPlacemark = destinationPlacemark
        print("At Beginning: \(destinationPlacemark.coordinate)")
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = self.article.name
        print(" Before requestlocation: \(destinationPlacemark.coordinate)")
        self.mapView.setCenter(destinationPlacemark.coordinate, animated: true)
        dropPinZoomIn(placemark: destinationPlacemark)
        
        myLocationManager.requestLocation(completionHandler: { location in
            print("from viewController\(location)")

            let distance = self.distanceSlider.value
            // create a MapItem for source
            let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
            self.mapView.showsUserLocation = true // 顯示自己位置
            //create a MapItem for destination
            let destinationMapItem = MKMapItem(placemark: self.destinationPlacemark!)
            currentLocationMapItem.name = "出發點"
            destinationMapItem.name = self.article.location
            // 將起迄點放到陣列中
            let routes = [currentLocationMapItem, destinationMapItem]
            let request = MKDirectionsRequest()
            request.source = currentLocationMapItem
            request.destination = destinationMapItem
            request.transportType = .walking
            self.request = request
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print("viewDidAppear")
        mapView.delegate = self
        dropPinZoomIn(placemark: self.destinationPlacemark!)
        print("viewDidAppear to  get Direction: \(self.destinationPlacemark?.coordinate)")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("viewWillAppear")
        mapView.delegate = self
        dropPinZoomIn(placemark: self.destinationPlacemark!)
        print("viewWillAppear to  get Direction: \(self.destinationPlacemark?.coordinate)")
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
    
    func getDirections(){
        let directions = MKDirections(request: self.request)
            directions.calculateETA(completionHandler: { response, error in
                if let error = error {
                    print("路徑規劃錯誤: \(error)")
                    return
                }
                let response = response!
                print("結果: \(response.expectedTravelTime / 60),\(response.distance)")
                let pointAnnotation = MKPointAnnotation()
                self.mapView.removeAnnotations(self.mapView.annotations) //把先前加的點先清除
                self.dropPinZoomIn(placemark: self.destinationPlacemark!)
                // self.mapView.showAnnotations([pointAnnotation], animated: true)
                self.mapView.selectAnnotation(pointAnnotation, animated: true)
                // 設定為 walking 模式
                let options = [MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeWalking]
                // 開啟地圖開始導航
                let routes = [self.request.source, self.request.destination]
                MKMapItem.openMaps(with: routes as! [MKMapItem], launchOptions: options)
        
                DispatchQueue.main.async {
                    self.storeDistanceLabel.text = "\(Int(response.distance)) m"
                    let walkTime = Int(response.expectedTravelTime / 60 )
                    self.walkingTimeLabel.text = "\(walkTime) min."
                    self.mapView.setCenter(pointAnnotation.coordinate, animated: true)
                }
                self.mapView.showsCompass = true
                self.mapView.showsTraffic = true
                self.mapView.showsScale = true
                print("End of get Direction: \(self.destinationPlacemark?.coordinate)")
            })  // end of get Direction
     }
    
    func dropPinZoomIn(placemark:MKPlacemark){
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
    }
}








