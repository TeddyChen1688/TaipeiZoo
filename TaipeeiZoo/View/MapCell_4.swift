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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(lat: Double, lng: Double, location: String) {
 
        let destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        // Add annotation
       //  print("destinationCoordinate from MapCell is \(destinationCoordinate)")
       // print("location from MapCell is \(location)")
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
    
        //create a MapItem for destination

        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = location
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = destinationCoordinate
        pointAnnotation.title = location
        
       // print("pointAnnotation.title from MapCell is \(pointAnnotation.title)")
        self.mapView.addAnnotation(pointAnnotation)
        
        let degree = 0.5 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: destinationCoordinate, span: span)
        self.mapView.region = region
        
        // Set the zoom level
        // let region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 100, 100)
        self.mapView.setRegion(region, animated: false)
    }
}
