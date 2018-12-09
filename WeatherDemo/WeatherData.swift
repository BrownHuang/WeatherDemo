//
//  WeatherData.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/7.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

class WeatherData: NSObject {
    
    // MARK: Property value
    
    // 日期
    var weatherDate: String = ""
    
    // 時間
    var weatherTime: String = ""
    
    // 最低溫
    var weatherLow: String = ""
    
    // 最高溫
    var weatherHigh: String = ""
    
    // 天氣狀態
    var weatherStatus: String = ""
    
    
    // MARK: Public function
    
    func updateWithArray(array: [String]){
    
        self.weatherDate = array[0]
        
        self.weatherTime = array[1]
        
        self.weatherLow = array[2]
        
        self.weatherHigh = array[3]
        
        self.weatherStatus = array[4]
        
    }
    
    // MARK: Inherit function
    
    override var description: String {
        
        return "weatherDate = " + self.weatherDate + " " + "weatherTime = " + self.weatherTime + " " + "weatherLow = " + self.weatherLow + " " + "weatherHigh = " + self.weatherHigh + " " + "weatherStatus = " + self.weatherStatus
    }


}
