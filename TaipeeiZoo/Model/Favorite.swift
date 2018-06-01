//
//  Favorite.swift
//  TaipeiZoo
//
//  Created by eva on 2018/6/1.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import Foundation

class Favorite {
    var name: String
    var description: String
    var image: String
    var isVisited: Bool

    var managedObject: FavoriteMO?
    
    init(name: String,  description: String, image: String, isVisited: Bool) {
        
        self.name = name
        self.description = description
        self.image = image
        self.isVisited = isVisited

    }
    
    convenience init() {
        self.init(name: "",  description: "", image: "", isVisited: false)
    }
}
