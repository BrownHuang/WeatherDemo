//
//  AppDelegate.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/7.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Property value

    var window: UIWindow?

    // MARK: Lifecycle function

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //設定時間&電源狀態列為白色
        UIApplication.shared.statusBarStyle = .lightContent;
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

