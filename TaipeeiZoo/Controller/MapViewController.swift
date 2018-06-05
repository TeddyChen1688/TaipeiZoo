//
//  MapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/30.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import MapKit

class MapViewController: UIViewController,  MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var spinner = UIActivityIndicatorView()
    var articles = [Article](){
        didSet{
            DispatchQueue.main.async{
                self.spinner.stopAnimating()
            }
        }
    }
    var article: Article!
    var animalSectionTitles = [String]()
    var animalsDict = [String: [Article]]()
    let locationManager = CLLocationManager()
    
    var buildings:[Building] = [
        Building(name: "大貓熊館", lat: 24.9971109, lng: 121.5831587),
        Building(name: "企鵝館", lat: 24.9931338, lng: 121.5907654),
        Building(name: "沙漠動物區", lat: 24.9952281, lng: 121.5852535),
        Building(name: "亞洲熱帶雨林區", lat: 24.9940478, lng: 121.5840505),
        Building(name: "兒童動物區", lat: 24.9992805, lng: 121.5824023),
        Building(name: "兩棲爬蟲動物館", lat: 24.9940697, lng: 121.5898494),
        Building(name: "昆蟲館", lat: 24.9967402, lng: 121.5807004),
        Building(name: "非洲動物區", lat: 24.9938388, lng: 121.5878686),
        Building(name: "鳥園區", lat: 24.9954408, lng: 121.5898159),
        Building(name: "無尾熊館", lat: 24.9983738, lng: 121.5823688),
        Building(name: "溫帶動物區", lat: 24.992278, lng: 121.5892527),
        Building(name: "臺灣動物區", lat: 24.9971255, lng: 121.5809003),
        Building(name: "澳洲動物區", lat: 24.9942934, lng: 121.5853554)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let degree = 1 * 1.0 / 111
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
        
        for building in buildings{
            let Annotation = MKPointAnnotation()
            Annotation.coordinate = CLLocationCoordinate2D(latitude: building.lat, longitude: building.lng)
            Annotation.title = building.name
            mapView.addAnnotation(Annotation)
            let Placemark = MKPlacemark(coordinate: Annotation.coordinate, addressDictionary: nil)
            let MapItem = MKMapItem(placemark: Placemark)
            mapView.addAnnotation(Annotation)
            
            let region = MKCoordinateRegionMake(Placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        mapView.delegate = self
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        downLoadLatestArticles()
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // 定義旋轉指示器的佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        // 啟用旋轉指示器
        spinner.startAnimating()
    }
    
    func downLoadLatestArticles(){
        Article.downLoadItem { (articles, error) in
            if let error = error {
                print("fail \(error)")
                return
            }
            let articles = articles!
            print(articles)
            articles.sorted(by: { $0.name_EN! < $1.name_EN! })
            var animalsDict = [String: [Article]]()
            var animalSectionTitles = [String]()
            
            for article in articles {
                // 取得動物名的第一個字母並建立字典
                let animalKey = String(article.name_EN!.first!)
                print("\(animalKey)")
                if var animalValues = animalsDict[animalKey] {
                    animalValues.append(article)
                    animalsDict[animalKey] = animalValues
                } else {
                    animalsDict[animalKey] = [article]
                }
            }
            animalSectionTitles = [String](animalsDict.keys)
            animalSectionTitles = animalSectionTitles.sorted(by: { $0 < $1 })
            self.animalSectionTitles = animalSectionTitles
            self.animalsDict = animalsDict
            self.articles = articles
        }
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
        button.setImage(UIImage(named: "phone"), for: .normal)
        // button.addTarget(self, action: nil, for: UIControlEvents.touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainList"{
            print("翻頁了...")
            let nextVC = segue.destination as! ArticleListViewController
            nextVC.articles = self.articles
            nextVC.animalSectionTitles = self.animalSectionTitles
            nextVC.animalsDict = self.animalsDict
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//        // 移動地圖
//        

