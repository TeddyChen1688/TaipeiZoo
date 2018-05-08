//
//  ViewController.swift
//  TaipeeiZoo
//
//  Created by Teddy on 2018/5/6.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = URLSession.shared
        let url = URL (string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")!
        print("\(url)")
        
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                print("API 下載錯誤:\(error)")
                return
            }
            let data = data! //必定有資料 ！！
            print("data amount \(data)")
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as![String:[String: Any]], let results = jsonObject["result"]!["results"] as? [[String: Any]]
               {
                for result in results{
                    var item = Item()
                    item.name = result["A_Name_Ch"] as! String
                    item.location = result["A_Location"] as! String
                    item.habit = result["A_Habitat"] as! String
                    item.image_URL = result["A_Pic01_ALT"] as! String
                    self.items.append(item)
                    
                }
                
//                if results.count == 0 {
//                    print("解析資料不成")
//                    return
//                }
//                let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
//                let result = results[randomIndex]
                print("Data==> \(self.items)")
           }
        })
    task.resume()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

