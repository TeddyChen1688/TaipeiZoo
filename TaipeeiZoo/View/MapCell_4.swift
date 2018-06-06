//
//  MapCell_4.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit
class MapCell_4: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!

    func configure(lat: Double, lng: Double, location: String) {
 
        let destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationCoordinate
        annotation.title = location
        self.mapView.addAnnotation(annotation)
        
        let degree = 0.5 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: destinationCoordinate, span: span)
       // self.mapView.region = region
        self.mapView.setRegion(region, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
