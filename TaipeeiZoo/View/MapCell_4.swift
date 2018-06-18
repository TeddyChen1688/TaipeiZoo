//
//  MapCell_4.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/2.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import MapKit
class MapCell_4: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
   

    func configure(lat: Double, lng: Double, location: String) {
         mapView.delegate = self
 
        let destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationCoordinate
        annotation.title = location
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        let degree = 0.5 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        let region = MKCoordinateRegion(center: destinationCoordinate, span: span)
       // self.mapView.region = region
        self.mapView.setRegion(region, animated: false)
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
        pinView?.leftCalloutAccessoryView = nil
        return pinView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
