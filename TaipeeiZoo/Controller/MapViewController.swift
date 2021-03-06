//
//  MapViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/30.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController,  MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
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
    var annotations = [MKAnnotation]()
    var spinner = UIActivityIndicatorView()
    
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
        navigationController?.navigationBar.tintColor = UIColor(red:0.0/255.0, green: 67.0/255.0, blue: 255.0/255.0, alpha: 1.0)
         navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        var annotations = [MKAnnotation]()
        for building in buildings{
        let Annotation = MKPointAnnotation()
            Annotation.coordinate = CLLocationCoordinate2D(latitude: building.lat, longitude: building.lng)
            Annotation.title = building.name
            annotations.append(Annotation)
        }
       mapView.showAnnotations(annotations, animated: true)
        

        
        
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        
        downLoadLatestArticles()
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // 定義旋轉指示器的佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        // 啟用旋轉指示器
        spinner.startAnimating()
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(red:0.0/255.0, green: 67.0/255.0, blue: 255.0/255.0, alpha: 1.0)
//       navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//       navigationController?.navigationBar.shadowImage = nil
       self.navigationController?.navigationBar.isTranslucent = true
        print("viewWillAppear")
    //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func downLoadLatestArticles(){
        Article.downLoadItem { (articles, error) in
            if let error = error {
                print("fail \(error)")
                return
            }
            guard let articles = articles?.sorted(by: { $0.name_EN! < $1.name_EN! }) else{return}
            var animalsDict = [String: [Article]]()
            var animalSectionTitles = [String]()
            
            for article in articles {   // 取得動物名的第一個字母並建立字典
                let animalKey = String(article.name_EN!.first!)
               // print("\(animalKey)")
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
        pinView?.leftCalloutAccessoryView = nil
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
    }
}

