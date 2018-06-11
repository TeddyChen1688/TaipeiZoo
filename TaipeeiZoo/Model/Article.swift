//
//  Item.swift
//  TaipeeiZoo
//  本例, 可以作為從 OpenData 下載 JSON 資料源,在表格畫出來的定式, 可以在衍伸出來一個轉場到細節視圖.
//  1. 網路下載放在資料 Model 裡: 根據原始資料的格式決定資料陣列在下載一包的位置. 在本例是第三層.
//  2. 一包下來,所有的內容,設成一個陣列 arrayDict, 是一個中間陣列.
//  3. 部署一個資料 Model(Article), 資料從 arrayDict 抓出來放進去包成物件 Article 的陣列.
//  4. 在部署 Article 的時候,把需要擷取的資料,在本例是 5+1 個,設成屬性.不要擷取的資料可以省掉這動作
//  5. 轉場到視圖再拆開物件取出屬性指定給 UI 元件.
//  Created by Teddy on 2018/5/7.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import Foundation

let ArticlesUrl = URL (string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")!

class Article {
    var id: String
    var name: String?
    var name_EN: String?
    var location: String?
    var distribution: String?
    var habit: String?
    var feature: String?
    var behavior: String?
    var diet: String?
    var Pic01_URLString: String?
    var Pic02_URLString: String?
    var video_URLString: String?
    var Voice01_URLString: String?
    var imageHeight: CGFloat = 0.0
    var geo: String?
    var lng: Double = 0.0
    var lat: Double = 0.0
    var chk_flag: Bool = false
    var chk_video: Bool = true

    
    init(rawData: [String: Any]){
        id = rawData["_id"] as! String
        name = rawData["A_Name_Ch"] as? String
        name_EN = rawData["A_Name_En"] as? String
        location = rawData["A_Location"] as? String
        distribution = rawData["A_Distribution"] as? String
        habit = rawData["A_Habitat"] as? String
        feature = rawData["A_Feature"] as? String
        behavior = rawData["A_Behavior"] as? String
        diet = rawData["A_Diet"] as? String
        Pic01_URLString = rawData["A_Pic01_URL"] as? String
        Pic02_URLString = rawData["A_Pic02_URL"] as? String
        video_URLString = rawData["A_Vedio_URL"] as? String
        Voice01_URLString = rawData["A_Voice01_URL"] as? String
        geo = rawData["A_Geo"] as? String
    
    }

    class func downLoadItem(completionHandler:@escaping ([Article]?, Error?) -> Void){
    
        let session = URLSession.shared
        let task = session.dataTask(with: ArticlesUrl){(data,response,error) in
            if let error = error {
                print ("下載失敗!!")
                completionHandler(nil,error)
                return
            }
            let data = data!
            print("data amount \(data)")
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as![String:[String: Any]], let articleArray = jsonObject["result"]!["results"] as? [[String: Any]]{
                
                var articles = [Article]()
                for articleDict in articleArray{
                    let article = Article(rawData: articleDict)
                    
                    for article_OK in articles {
                        if article.name == article_OK.name  {
                            article.chk_flag = true
                        }
                    }
                    
                    if article.chk_flag == true {
                     //   print("same data is downloaded")
                    }
                    else {
                        
                        if article.name_EN == "" {
                           //  print("name_EN 抓取失敗")
                            article.name_EN = "To Be Determined"
                        }

                        
                        if article.id == "191" || article.id == "192" || article.id == "194" {
                            let startIndex = article.name_EN?.index((article.name_EN?.startIndex)!, offsetBy: 1)
                            article.name_EN = article.name_EN?.substring(from: startIndex!)
                     //       print(article.name_EN!)
                    
                        }
                            
                        if article.id == "27" || article.id == "71" || article.id == "84" || article.id == "237" || article.id == "72" || article.id == "86"{
                            let startIndex = article.name_EN?.index((article.name_EN?.startIndex)!, offsetBy: 1)
                            article.name_EN = article.name_EN?.substring(from: startIndex!)
                      //      print(article.name_EN!)
                        }
                        //else { print("字首正確")}
                        
                        article.name_EN = article.name_EN?.capitalized
                    
                        if article.location == "" {
//                            print("Location 抓取失敗")
                            article.location = "展館待定"
                        }
                       // else { print("Location 抓取成功")}
                        
                        if article.distribution == "" {
                            //                            print("Location 抓取失敗")
                            article.distribution = "( 目前查無資料 )"
                        }
                      //   else { print("distribution 抓取成功 \(article.distribution)")}
                        
                        if article.habit == "" {
//                            print("habit 抓取失敗")
                            article.habit = "( 目前查無資料 )"
                        }
                       // else { print(" feature 抓取成功")}
                        if article.feature == "" {
//                            print("habit 抓取失敗")
                            article.feature = "( 目前查無資料 )"
                        }
                        //else { print("feature 抓取成功")}
                        
                        if article.behavior == "" {
                            //                            print("Location 抓取失敗")
                            article.behavior = "( 目前查無資料 )"
                        }
                     //   else { print("behavior 抓取成功 \(article.behavior)")}
                        
                        if article.diet == "" {
//                            print("habit 抓取失敗")
                            article.diet = "( 目前查無資料 )"
                        }
                       // else { print("diet 抓取成功")}
                        
                        if article.Pic02_URLString == "" {
//                            print("Pic02_URLString 抓取失敗")
                            article.Pic02_URLString = article.Pic01_URLString
                        }
                        //else { print("Pic02_URLString 抓取成功")}
                        
                        if article.video_URLString == "" {
                        //  print("video_URLString 抓取失敗")
                            article.video_URLString = "https://www.youtube.com/watch?v=6QxKgcjgxWw"
                            article.chk_video = false
                        }
                        //else { print("video_URLString 抓取成功")}
                        
                        if article.geo == ""
                        {
                            article.geo = "MULTIPOINT ((121.5831587 24.9971109))"
                        //    print("assign a Geo")
                        }
                        //else { print("geo 抓取成功")}
                        
                        let geo = article.geo
                       // print("Geo is \(String(describing: geo))")
                        let geo_StringA = geo?.split(separator: "(", maxSplits: 3)[1]
                        let geo_StringB = geo_StringA?.split(separator: ")", maxSplits: 3)[0]
                        let geo_array = geo_StringB?.split(separator: " ", maxSplits: 3)
                        let lng_String = String((geo_array?.first!)!) as NSString
                        let lng = lng_String.doubleValue
                        article.lng = lng
                        //print("lng is \(lng)")
                        let lat_String = String((geo_array?.last!)!) as NSString
                        let lat = lat_String.doubleValue
                        article.lat = lat
                        //print("lat is \(lat)")
                        
                        articles.append(article)                    }
                    
                }
                print("下載完成 \(articles.count)")
                completionHandler(articles, nil)
            }
        }
        task.resume()
    }
    
}

