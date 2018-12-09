//
//  NetworkManger.swift
//  HTMLParserDemo
//
//  Created by Bo-Rong Huang on 2018/12/9.
//  Copyright © 2018年 Bo-Rong Huang. All rights reserved.
//

import UIKit

import Kanna

enum  NetworkAPIFunctional : Int{
    
    case
    None = 0,
    APIFunction_01,         // 取得每日一句資料
    APIFunction_02          // 取得一週天氣資料
    
}

@objc protocol NetworkMangerDelegate: NSObjectProtocol {
    
    // 已取得每日一句資料
    @objc optional func getDailySayFromNetworkFinsh(string: String)
    
    // 已取得一週天氣資料
    @objc optional func getWeekWeatherFromNetworkFinsh(arrayData: Array<WeatherData>)

}

class NetworkManger: NSObject, XMLParserDelegate {
    
    // MARK: Property value
    
    private static var sharedInstanced: NetworkManger?
    
    var delegate: NetworkMangerDelegate?
    
    var eName: String = ""
    
    var dataContent = ""
    
    var oriDownLoadData: [String] = []
    
    var weathers: [WeatherData] = []

    
    // MARK: Public function
    
    static func sharedInstance() -> NetworkManger {
        
        if(sharedInstanced == nil){
            
            sharedInstanced = NetworkManger()
            
            sharedInstanced?.initData()
            
        }
        
        return sharedInstanced!
        
    }
    
    // MARK: Private function
    
    private func initData() {
    
    }
    
    // 讀取天氣資訊
    func readWeatherData() {
        
        weathers.removeAll()
        
        if(oriDownLoadData.count >= 2){
            oriDownLoadData.remove(at: 0);
            
            var array: [String] = [];
            
            array = (oriDownLoadData.first?.replacingOccurrences(of: "\n\t", with: "").components(separatedBy: "<BR>"))!
            array.removeLast()
            
            if (array.count > 0) {
                
                for i in 0 ... array.count - 1 {
                    
                    let dataArray = array[i].replacingOccurrences(of: "溫度:", with: "").replacingOccurrences(of: " ~", with: "").components(separatedBy: " ")
                    
                    let weatherData = WeatherData()
                    weatherData.updateWithArray(array: dataArray)
                    
                    weathers.append(weatherData)

                }
                
            }
            
            DispatchQueue.main.async {
                
                if(self.delegate != nil){
                    if (self.delegate?.responds(to: #selector(self.delegate?.getWeekWeatherFromNetworkFinsh(arrayData:))))!{
                        self.delegate?.getWeekWeatherFromNetworkFinsh!(arrayData: self.weathers)
                    }
                }
                
            }
            
            
        }
        
    }
    
    // MARK: Public function
    
    func getDataWithNetworkAPIFunctional(networkAPIFunctional: NetworkAPIFunctional) {
        
        print((#file as NSString).lastPathComponent, "->", #function, "APIFunction_0\(networkAPIFunctional.rawValue)")

        if (networkAPIFunctional == NetworkAPIFunctional.APIFunction_01) {
            // 取得每日一句資料
            
            let urlDemo = URL.init(string: "https://tw.appledaily.com/index/dailyquote/")!
            let task = URLSession.shared.dataTask(with: urlDemo) { (data, response, error) in
                
                if (data != nil){
                    let data = data!
                    
                    DispatchQueue.main.async {
                        
                        if let doc = HTML(html: data, encoding: .utf8){
                            
                            if let nodeA = doc.xpath("//*[@id=\"" + "maincontent" + "\"]/div[2]/article/p").first {
                                
                                if let dailySayString = nodeA.innerHTML {
                                    
                                    DispatchQueue.main.async {
                                        if (self.delegate != nil){
                                            if (self.delegate?.responds(to: #selector(self.delegate?.getDailySayFromNetworkFinsh(string:))))!{
                                                self.delegate?.getDailySayFromNetworkFinsh!(string: dailySayString)
                                            }
                                        }
                                    }
                                
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        
        }
        else if (networkAPIFunctional == NetworkAPIFunctional.APIFunction_02) {
            // 取得一週天氣資料
            
            let weatherURL = URL.init(string: "https://www.cwb.gov.tw/rss/forecast/36_08.xml")!
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

        
    }
    
    
    // MARK: XMLParserDelegate function
    
    // 開始解析 XML
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        
        if(eName == "item"){
            dataContent = ""
        }
        
        
    }
    
    // 正在解析 XML
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (data.isEmpty == false){
            
            if (eName == "description"){
                dataContent += data;
            }
            
        }
        
        
        
    }
    
    // 結束解析 XML
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName == "item"){
            
            oriDownLoadData.append(dataContent);
            
            self.readWeatherData()
            
        }
        
    }

    
}
