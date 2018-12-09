//
//  RealmManager.swift
//  RealmDemo
//
//  Created by Bo-Rong Huang on 2018/12/9.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

import RealmSwift

@objc protocol RealmManagerDelegate: NSObjectProtocol {
    
    // 已新增資料
    @objc optional func addDataFromDBFinsh()
    
    // 已刪除資料
    @objc optional func deleteDataFromDBFinsh()
    
    // 查詢資料完成
    @objc optional func queryDataFromDBFinsh()
    
    // 已更新資料
    @objc optional func updateDataFromDBFinsh()
    
    // 已新增每日一句資料
    @objc optional func addDailySayDataFromDBFinsh()

}

class RealmManager: NSObject {
    
    // MARK: Property value
    
    private static var sharedInstanced: RealmManager?
    
    var delegate: RealmManagerDelegate?
    
    let realm: Realm = try! Realm()
    

    // MARK: Public function
    
    static func sharedInstance() -> RealmManager{
        
        if (sharedInstanced == nil) {
            
            sharedInstanced = RealmManager();
            
            sharedInstanced?.initData()

        }
        
        return sharedInstanced!
        
    }
    
    // MARK: Private function
    
    private func initData(){
        
    }
    
    // MARK: Publuc function
    
    // 新增資料
    func addDataFromDB(weatherData: RLM_WeatherData) {
    
        try! realm.write {
            realm.add(weatherData)
            
            DispatchQueue.main.async {
                if (self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.addDataFromDBFinsh)))!{
                        self.delegate?.addDataFromDBFinsh!()
                    }
                }
            }

            
        }
        
    }
    
    // 刪除資料
    func deleteDataFromDB(weatherData: RLM_WeatherData) {
        
        let queryData = realm.objects(RLM_WeatherData.self).filter("weatherDate CONTAINS '\(weatherData.weatherDate)' AND weatherTime CONTAINS '\(weatherData.weatherTime)'")
        
        try! realm.write {
            realm.delete(queryData)
                        
            DispatchQueue.main.async {
                if (self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.deleteDataFromDBFinsh)))!{
                        self.delegate?.deleteDataFromDBFinsh!()
                    }
                }
            }
            
        }
        
    }
    
    // 查詢資料
    func queryDataFromDB(weatherDate: String, weatherTime: String) -> Results<RLM_WeatherData> {
    
        let queryData = realm.objects(RLM_WeatherData.self).filter("weatherDate CONTAINS '\(weatherDate)' AND weatherTime CONTAINS '\(weatherTime)'")
        
        return queryData
        
    }
    
    // 修改資料
    func updateDataFromDB(weatherData: RLM_WeatherData, newWeatherData: RLM_WeatherData) {
    
        let queryData = realm.objects(RLM_WeatherData.self).filter("weatherDate CONTAINS '\(weatherData.weatherDate)' AND weatherTime CONTAINS '\(weatherData.weatherTime)'")
        
        try! realm.write {

            queryData.first?.weatherDate = newWeatherData.weatherDate
            queryData.first?.weatherTime = newWeatherData.weatherTime
            queryData.first?.weatherLow = newWeatherData.weatherLow
            queryData.first?.weatherHigh = newWeatherData.weatherHigh
            queryData.first?.weatherStatus = newWeatherData.weatherStatus
            
            DispatchQueue.main.async {
                if (self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.updateDataFromDBFinsh)))!{
                        self.delegate?.updateDataFromDBFinsh!()
                    }
                }
            }
            

        }


    }
    
    // 移除所有資料
    func deleteAllDataFromDB() {
    
        try! realm.write {
            realm.deleteAll()
            
            DispatchQueue.main.async {
                if (self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.deleteDataFromDBFinsh)))!{
                        self.delegate?.deleteDataFromDBFinsh!()
                    }
                }
            }
            
        }
        
    }
    
    // 新增每日一句資料
    func addDailySayFromDB(dailySayData: RLM_DailySayData) {
        
        try! realm.write {
            realm.add(dailySayData)
            
            DispatchQueue.main.async {
                if (self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.addDailySayDataFromDBFinsh)))!{
                        self.delegate?.addDailySayDataFromDBFinsh!()
                    }
                }
            }
            
            
        }
        
    }
    
}
