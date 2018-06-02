//
//  DetailMapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit

class DetailMapViewController: UIViewController, MKMapViewDelegate{

    var article: Article!
    
    let myLocationManager = MyLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceChangedLabel: UILabel!

    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var walkingTimeLabel: UILabel!

    @IBAction func distanceChanged(_ sender: Any) {
        let distance = round(distanceSlider.value * 10) / 10
        distanceChangedLabel.text = "\(distance) km"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        
        let mkPoint = MKPointAnnotation()

        mkPoint.coordinate = CLLocationCoordinate2D(latitude: article.lat, longitude: article.lng)
        mkPoint.title = article.name
        mkPoint.subtitle = article.location
        
        mapView.addAnnotation(mkPoint)
        
        let degree = 1.5 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: mkPoint.coordinate, span: span)
        mapView.region = region

        
        // 移動地圖
        mapView.setCenter(mkPoint.coordinate, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
