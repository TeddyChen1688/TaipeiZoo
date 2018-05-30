//
//  MapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/30.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let a1 = MKPointAnnotation()
        let a2 = MKPointAnnotation()
        let a3 = MKPointAnnotation()
        
        a1.coordinate = CLLocationCoordinate2D(latitude: 24.9971109, longitude: 121.5831587)
        a2.coordinate = CLLocationCoordinate2D(latitude: 24.9931338, longitude: 121.5907654)
        a3.coordinate = CLLocationCoordinate2D(latitude:  24.9952281, longitude: 121.5852535)
        
        a1.title = "大貓熊館"
        a2.title = "企鵝館"
        a3.title = "沙漠動物區"
        
        a1.subtitle = "動物園"
        a2.subtitle = "動物園"
        a3.subtitle = "動物園"
        
        mapView.addAnnotation(a1)
        mapView.addAnnotation(a2)
        mapView.addAnnotation(a3)
        
        let degree = 1.5 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: a3.coordinate, span: span)
        mapView.region = region
    
        
        // 移動地圖
        mapView.setCenter(a3.coordinate, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
