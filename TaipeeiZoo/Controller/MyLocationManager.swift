//
//  MyLocationManager.swift
//  wheretoLunch
//
//  Created by Teddy Chen on 2017/3/11.
//  Copyright © 2017年 Teddy. All rights reserved.
//
import UIKit
import CoreLocation
class MyLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completionHandler: ((CLLocation) -> Void)?
    var isRequestingLocation = false
    // 1. 指定本身是跟 CLLocationManager 存取位置資料的主體
    override init(){
        super.init() //先執行父類的初始化 再進行覆寫.
        locationManager.delegate = self
  }
    //   2. 使用 requestLocation 方法存取位置資料, 結果放在 completionHandler, datatype 是 CLLocation
    func requestLocation(completionHandler: @escaping ((CLLocation) -> Void)) {
        // 接住 ViewController 傳遞過來的 completionHandler,因為還沒有生成 location 結果,先存成屬性接下去進行
        self.completionHandler = completionHandler
        isRequestingLocation = true
        
        // 2.1 根據規則:須先獲得存取位置資料許可權
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        // 2.1 根據規則:須先指定存取位置精度
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // 2.3 核心方法: 執行存取位置
        locationManager.requestLocation()
    } // end of closure of requestLocation
    
        // 3. 取得 location 之後呼叫這方法 didUpdateLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isRequestingLocation{
            return  // Early return: 檢查執行的條件 已經取到地址 --> 不再取了
        }
        isRequestingLocation = false
        let location = locations.first! // 何時指定 locations 的 dataType 是 [CLLocation] ?
        // 取得 location,就呼叫先前被存成屬性的 Handler,它的內容是回到 ViewController 去執行 Handler規範的動作
        completionHandler?(location)
    }
    // 4. 錯誤就回報
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print("didFailWithError")
    }
}
