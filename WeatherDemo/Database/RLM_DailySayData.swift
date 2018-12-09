//
//  RLM_DailySayData.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/9.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

import RealmSwift

class RLM_DailySayData: Object {

    // 日期
    @objc dynamic var dailySayDate = ""
    
    // 內文
    @objc dynamic var dailySayContent = ""
    
    
}
