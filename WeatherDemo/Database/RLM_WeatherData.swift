//
//  RLM_WeatherData.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/9.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

import RealmSwift

class RLM_WeatherData: Object {
    
    // 日期
    @objc dynamic var weatherDate = ""
    
    // 時間
    @objc dynamic var weatherTime = ""
    
    // 最低溫
    @objc dynamic var weatherLow = ""
    
    // 最高溫
    @objc dynamic var weatherHigh = ""
    
    // 天氣狀態
    @objc dynamic var weatherStatus = ""
    
    // MARK: Public function
    
    func updateWithArray(array: [String]){
        
        self.weatherDate = array[0]
        
        self.weatherTime = array[1]
        
        self.weatherLow = array[2]
        
        self.weatherHigh = array[3]
        
        self.weatherStatus = array[4]
        
    }

}
