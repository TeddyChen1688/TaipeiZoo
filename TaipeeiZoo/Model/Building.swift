//
//  Building.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/5.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation
class Building {

    var name: String
    var lat: Double
    var lng: Double
    
    init(name: String, lat: Double, lng: Double){
        self.name = name
        self.lat = lat
        self.lng = lng
    }
        
    convenience init() {
        self.init(name: "", lat: 0.0, lng: 0.0 )
    }
        
}
