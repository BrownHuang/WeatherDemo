//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/7.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkMangerDelegate, RealmManagerDelegate {

    // MARK: define private univerasl vale
    
    let tableViewCellID = "weatherCell"
    
    // MARK: Property value
    
    @IBOutlet weak var weatherStatusTitle: UILabel!
    
    @IBOutlet weak var weatherTemperatureTitle: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var dailySayTitle: UILabel!
    
    let m_refreshControl: UIRefreshControl = UIRefreshControl.init()

    
    // MARK: Lifecycle function
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initData()
        
        initUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NetworkManger.sharedInstance().delegate = self
        RealmManager.sharedInstance().delegate = self
        
        updateData()
        
        updateUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NetworkManger.sharedInstance().delegate = nil
        RealmManager.sharedInstance().delegate = nil
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Init data function
    
    func initData() {
        
    }
    
    // MARK: Init ui function
    
    func initUI() {
        
        let imgBackground = UIImage.init(named: "background.png");
        if (imgBackground != nil){
            let imgBackground = imgBackground!
            
            self.view.backgroundColor = UIColor.init(patternImage: imgBackground)

        }
        
        self.weatherTableView.separatorStyle = .none
        
        m_refreshControl.tintColor = UIColor.white
        m_refreshControl.addTarget(self, action: #selector(refreshTableDataFromBegin), for: .valueChanged)
        m_refreshControl.isUserInteractionEnabled = false
        self.weatherTableView.addSubview(m_refreshControl)
        
    }
    
    // MARK: Private function
    
    private func updateData() {
    
        RealmManager.sharedInstance().deleteAllDataFromDB()

        NetworkManger.sharedInstance().getDataWithNetworkAPIFunctional(networkAPIFunctional: NetworkAPIFunctional.APIFunction_01)
        
        NetworkManger.sharedInstance().getDataWithNetworkAPIFunctional(networkAPIFunctional: NetworkAPIFunctional.APIFunction_02)
        
    }
    
    // 更新畫面
    private func updateUI() {
        
        self.weatherStatusTitle.text = RealmManager.sharedInstance().realm.objects(RLM_WeatherData.self).sorted(byKeyPath: "weatherDate").first?.weatherStatus
        
        self.weatherTemperatureTitle.text = RealmManager.sharedInstance().realm.objects(RLM_WeatherData.self).sorted(byKeyPath: "weatherDate").first?.weatherHigh
        
        self.weatherTableView.reloadData()
        
        self.dailySayTitle.text = RealmManager.sharedInstance().realm.objects(RLM_DailySayData.self).last?.dailySayContent

        
    }
    
    // 重新刷新頁面
    @objc private func refreshTableDataFromBegin() {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        m_refreshControl.endRefreshing()
        
        RealmManager.sharedInstance().deleteAllDataFromDB()
        
        NetworkManger.sharedInstance().getDataWithNetworkAPIFunctional(networkAPIFunctional: NetworkAPIFunctional.APIFunction_01)
        
        NetworkManger.sharedInstance().getDataWithNetworkAPIFunctional(networkAPIFunctional: NetworkAPIFunctional.APIFunction_02)

        
    }
    

    // MARK: NetworkMangerDelegate function
    
    func getDailySayFromNetworkFinsh(string: String) {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        let dailySayData = RLM_DailySayData()
        dailySayData.dailySayDate = NSDate().description
        dailySayData.dailySayContent = string
        
        RealmManager.sharedInstance().addDailySayFromDB(dailySayData: dailySayData)

    }
    
    func getWeekWeatherFromNetworkFinsh(arrayData: Array<WeatherData>) {
        
        print((#file as NSString).lastPathComponent, "->", #function)

        if (arrayData.count > 0) {
            
            for i in 0 ... arrayData.count - 1 {
                
                let weatherData = RLM_WeatherData()
                weatherData.weatherDate = arrayData[i].weatherDate
                weatherData.weatherTime = arrayData[i].weatherTime
                weatherData.weatherLow = arrayData[i].weatherLow
                weatherData.weatherHigh = arrayData[i].weatherHigh
                weatherData.weatherStatus = arrayData[i].weatherStatus
                
                RealmManager.sharedInstance().addDataFromDB(weatherData: weatherData)
                
            }
            
        }
        
    }
    
    // MARK: RealmManagerDelegate function
    
    func addDataFromDBFinsh() {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        self.updateUI()

    }
    
    func deleteDataFromDBFinsh() {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        self.updateUI()
        
    }
    
    func queryDataFromDBFinsh() {
        
        print((#file as NSString).lastPathComponent, "->", #function)

    }
    
    func updateDataFromDBFinsh() {
        
        print((#file as NSString).lastPathComponent, "->", #function)

    }
    
    func addDailySayDataFromDBFinsh() {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        self.updateUI()
    }
    
    // MARK: UITableViewDataSource function

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RealmManager.sharedInstance().realm.objects(RLM_WeatherData.self).count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! WeatherTableViewCell

        let results = RealmManager.sharedInstance().realm.objects(RLM_WeatherData.self).sorted(byKeyPath: "weatherDate")
        let weatherData = results[indexPath.row]
        
        cell.dateTimeTitle.text = weatherData.weatherDate + " " + weatherData.weatherTime
        cell.weatherStatusTitle.text = weatherData.weatherStatus
        cell.weatherTempTitle.text =  weatherData.weatherLow + " ~ " + weatherData.weatherHigh
        
        if(weatherData.weatherStatus.contains("雲")){
            cell.weatherIcon.image = UIImage.init(named: "Cloud.png")
        }
        
        if(weatherData.weatherStatus.contains("雨")){
            cell.weatherIcon.image = UIImage.init(named: "Rain.png")
        }
        
        if(weatherData.weatherStatus.contains("晴")){
            cell.weatherIcon.image = UIImage.init(named: "Sun.png")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        let results = RealmManager.sharedInstance().realm.objects(RLM_WeatherData.self).sorted(byKeyPath: "weatherDate")
        let weatherData = results[indexPath.row]
        
        self.view.makeToast("delete = \(weatherData.description)")
        
        if editingStyle == .delete {
            RealmManager.sharedInstance().deleteDataFromDB(weatherData: weatherData)
            self.weatherTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }




}

