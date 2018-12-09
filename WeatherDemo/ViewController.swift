//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Bo-Rong Huang on 2018/12/7.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

import Kanna

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource{

    // MARK: define private univerasl vale
    
    let weatherURL = URL.init(string: "https://www.cwb.gov.tw/rss/forecast/36_08.xml")!
    
    let urlDemo = URL.init(string: "https://tw.appledaily.com/index/dailyquote/")!
    
    let tableViewCellID = "weatherCell"
    
    // MARK: Property value
    
    let m_refreshControl: UIRefreshControl = UIRefreshControl.init()
    
    var oriDownLoadData: [String] = []
    var dataContent = ""

    var weathers: [WeatherData] = []
    var mainWeatherData: WeatherData = WeatherData()
    var eName: String = ""
    
    
    @IBOutlet weak var weatherStatusTitle: UILabel!
    
    @IBOutlet weak var weatherTemperatureTitle: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var dailySayTitle: UILabel!
    
    // MARK: Lifecycle function
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initData()
        
        initUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        updateData()
        
        updateUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Init data function
    
    func initData() {
        
        mainWeatherData.updateWithArray(array: ["12/08", "白天", "19", "27", "多雲"])
        
        self.downloadWeatherData()
        
        self.downloadDaySay()
        
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
    
    // MARK: Update function
    
    func updateData() {
    
    }
    
    func updateUI() {
        
        self.weatherStatusTitle.text = mainWeatherData.weatherStatus
        self.weatherTemperatureTitle.text = mainWeatherData.weatherHigh  + "°"
        
        self.weatherTableView.reloadData()
        
    }
    
    // MARK: Private function
    
    // 網路下載資料
    func downloadWeatherData() {
        
        weathers.removeAll()
        
        let task = URLSession.shared.dataTask(with: weatherURL) { (data, response, error) in
            
            if (data != nil){
                let data = data!
                
                let parse = XMLParser(data: data)
                parse.delegate = self
                parse.parse()
                
            }
            
        }
        
        task.resume()

    
    }
    
    // 網陸下載每日一句
    func downloadDaySay() {
        
        
        let task = URLSession.shared.dataTask(with: urlDemo) { (data, response, error) in
            
            print("response = " + (response?.description)!)
            
            if (data != nil){
                let data = data!

                let responseString = String(data: data, encoding: .utf8)
                
                if(responseString != nil){
                    let responseString = responseString!
                    
                    print("responseString = " + responseString)
                    
                }
                
                DispatchQueue.main.async {
                    
                    if let doc = HTML(html: data, encoding: .utf8){
                        
                        print("//*[@id=\"" + "maincontent" + "\"]/div[2]/article/p")
                        
                        if let nodeA = doc.xpath("//*[@id=\"" + "maincontent" + "\"]/div[2]/article/p").first {
                            
                            self.dailySayTitle.text = nodeA.innerHTML
                            
                        }
                    }
                    
                    
                }
                
            }
            
        }
        
        task.resume()
 
 
    }
    
    // 讀取天氣資訊
    func readWeatherData() {
        
        if(oriDownLoadData.count >= 2){
            oriDownLoadData.remove(at: 0);
            
            var array: [String] = [];
            
            array = (oriDownLoadData.first?.replacingOccurrences(of: "\n\t", with: "").components(separatedBy: "<BR>"))!
            array.removeLast()
            print(array)
            
            if (array.count > 0) {
                
                for i in 0 ... array.count - 1 {
                    
                    let dataArray = array[i].replacingOccurrences(of: "溫度:", with: "").replacingOccurrences(of: " ~", with: "").components(separatedBy: " ")
                    
                    let weatherData = WeatherData()
                    weatherData.updateWithArray(array: dataArray)
                    
                    weathers.append(weatherData)
                    
                }
                
                mainWeatherData = weathers.first!
                
            }
        
            print(weathers)
            
            self.updateUI()

            
        }
    
    }
    
    // 重新刷新頁面
    func refreshTableDataFromBegin() {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        m_refreshControl.endRefreshing()
        
        self.downloadWeatherData()
        
        self.downloadDaySay()
        
    }
    

    // MARK: XMLParserDelegate function
    
    // 開始解析 XML
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        eName = elementName
        
        if(eName == "item"){
            dataContent = ""
        }
        
        
    }
    
    // 正在解析 XML
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (data.isEmpty == false){
            
            if (eName == "description"){
                dataContent += data;
            }
            
        }


        
    }
    
    // 結束解析 XML
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print((#file as NSString).lastPathComponent, "->", #function)
        
        if (elementName == "item"){
            
            oriDownLoadData.append(dataContent);
            
            DispatchQueue.main.async {
                
                self.readWeatherData()

                
            }
            
        }
        
    }
    
    // MARK: UITableViewDelegate function
    
    
    // MARK: UITableViewDataSource function

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weathers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! WeatherTableViewCell

        let weatherData = weathers[indexPath.row]
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
        
        if editingStyle == .delete {
            
            weathers.remove(at: indexPath.row)
            self.weatherTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }




}

