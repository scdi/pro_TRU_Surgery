//
//  DataManager.swift
//  TRU-Pain
//
//  Created by jonas002 on 12/4/16.
//  Copyright © 2016 Jude Jonassaint. All rights reserved.
//
//  Thunderstorm (AppCoda tutorial) https://cocoacasts.com/building-a-weather-application-with-swift-3-fetching-weather-data/
//
//  Created by Bart Jacobs on 22/08/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.


import Foundation
import Alamofire
import CoreData
import UIKit


enum DataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class DataManager {
    
    
    
    typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
    
    let baseURL: URL
    
    private var _date: Date?
    private var _temp: String?
    private var _location: String?
    private var _weather: String?
    private var _url: URL?
    typealias JSONStandard = Dictionary<String, AnyObject>
    private var _taskUUID: String?
    private var _timestampString: String?
    private var _altitude: Double?
    private var _timestamp: Date?
    private var _dGeoData:DGeoData?
    var managedContext: NSManagedObjectContext!
    
    
    // MARK: - Initialization
        init(baseURL: URL) {
        self.baseURL = baseURL
         self.managedContext = getContext()


    }

    
    
    //GET ManageObjectContext
    func getContext () -> NSManagedObjectContext {

        let context = NSManagedObjectContext.default()
        return context!
        
    }

    
    // MARK: - Requesting Data
    
    func weatherDataForLocation(taskUUID: UUID, altitude: Double, latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        
        print("weather currently 1.")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        
        // Create URL
        let URL = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        _url = baseURL.appendingPathComponent("\(latitude),\(longitude)")
        
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }.resume()
        
        
        Alamofire.request(_url!).responseJSON(completionHandler: {
            response in
            let result = response.result
            if let dict = result.value as? JSONStandard {
                
                //print("weather currently")
                if (dict["currently"] as? JSONStandard) != nil {
                    
                    let icon = dict["currently"]?["icon"] as! String
                    let request = NSFetchRequest<DGeoData>(entityName: "DGeoData")
                    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                    let taskUUIDPredicate = NSPredicate(format: "taskUUID == %@", String(describing: taskUUID))
                    request.predicate = taskUUIDPredicate
                    request.sortDescriptors = [sortDescriptor ]
                    
                    var geoResults = [DGeoData]()
                    
                    do {
                        
                        geoResults =  try self.managedContext.fetch(request)
                        let geoDataToUpdate = geoResults[0]
                       
                            
                            if let username = SAMKeychain.password(forService: "comSicklesoftSMARTd", account: "username") {
                                geoDataToUpdate.participantID =  username
                            }
                            print("data manger task ID w \(taskUUID)")
                            geoDataToUpdate.icon = icon
                            geoDataToUpdate.latitude = latitude
                            geoDataToUpdate.longitude = longitude
                            geoDataToUpdate.altitude = String(format: "%.0f", altitude)
                            
                            let todayDictionary = dict["daily"] as? JSONStandard
                            let data = todayDictionary?["data"] as! NSArray
                            let dataJ = data[0] as! JSONStandard
                            print("dataJ")
                            print(dataJ)
                            print(dataJ["moonPhase"] as! Double)
                            let sunrise = dataJ["sunriseTime"] as! Double
                            let sunriseTime:Date = NSDate(timeIntervalSince1970: TimeInterval(sunrise)) as Date
                            let sunset = dataJ["sunsetTime"] as! Double
                            let sunsetTime:Date = NSDate(timeIntervalSince1970: TimeInterval(sunset)) as Date
                            let current = dict["currently"]?["time"] as! Double
                            let currentWeatherTimestamp:Date = NSDate(timeIntervalSince1970: TimeInterval(current)) as Date
                            
                            print(String(format: "%.0f",(dict["currenTTTly"]?["apparentTemperature"] as? Double) ?? "-9999999999999"))
                            
                            geoDataToUpdate.apparentTemperature = String(format: "%.0f",(dict["currently"]?["apparentTemperature"] as! Double))
                            geoDataToUpdate.apparentTemperatureMax = String(format: "%.0f",(dataJ["apparentTemperatureMax"] as! Double))
                            geoDataToUpdate.apparentTemperatureMin = String(format: "%.0f",(dataJ["apparentTemperatureMin"] as! Double))
                            geoDataToUpdate.cloudCover = String(format: "%.2f",(dict["currently"]?["cloudCover"] as! Double))
                            geoDataToUpdate.currentWeatherTimestampString = formatter.string(from: currentWeatherTimestamp as Date)
                            geoDataToUpdate.dailySummary = dataJ["summary"] as? String
                            geoDataToUpdate.dewPoint = String(format: "%.0f",(dict["currently"]?["dewPoint"] as! Double))
                            geoDataToUpdate.humidity = String(format: "%.2f",(dict["currently"]?["humidity"] as! Double))
                            geoDataToUpdate.moonPhase = String(format: "%.2f",(dataJ["moonPhase"] as! Double))
                            geoDataToUpdate.ozone = String(format: "%.0f",(dict["currently"]?["ozone"] as! Double))
                            geoDataToUpdate.pressure = String(format: "%.0f",(dict["currently"]?["pressure"] as! Double))
                            geoDataToUpdate.summary = dict["currently"]?["summary"] as? String
                            geoDataToUpdate.sunriseTimeString = formatter.string(from: sunriseTime as Date)
                            geoDataToUpdate.sunsetTimeTimeString = formatter.string(from: sunsetTime as Date)
                            geoDataToUpdate.temperature = String(format: "%.0f",(dict["currently"]?["temperature"] as! Double))
                            geoDataToUpdate.visibility = String(format: "%.1f",(dict["currently"]?["visibility"] as! Double))
                            geoDataToUpdate.windSpeed = String(format: "%.1f",(dict["currently"]?["windSpeed"] as! Double))
                            
                           //Save care
                            let manager = ListDataManager()
                            manager.saveGeoData()
                            
                        
                        
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                }
                
                
            }
            
        })
        
        
    }

    // MARK: - Helper Methods
    
    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
            
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
            completion(JSON, nil)
            
            print("serialized JSON \(JSON)")
            
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
}
//                    let apparentTemperature = String(format: "%.0f",(dict["currently"]?["apparentTemperature"] as! Double))
//                    let cloudCover = String(format: "%.2f",(dict["currently"]?["cloudCover"] as! Double))
//                    let dewPoint = String(format: "%.0f",(dict["currently"]?["dewPoint"] as! Double))
//                    let humidity = String(format: "%.2f",(dict["currently"]?["humidity"] as! Double))
//                    let icon = dict["currently"]?["icon"] as! String
//                    let ozone = String(format: "%.0f",(dict["currently"]?["ozone"] as! Double))
//                    let precipIntensity = String(format: "%.2f",(dict["currently"]?["precipIntensity"] as! Double))
//                    let precipProbability = String(format: "%.2f",(dict["currently"]?["precipProbability"] as! Double))
//                    let pressure   = String(format: "%.0f",(dict["currently"]?["pressure"] as! Double))
//                    let summary   = dict["currently"]?["summary"] as! String
//                    let temperature   = String(format: "%.0f",(dict["currently"]?["temperature"] as! Double))
//                    let time = String(format: "%.0f",(dict["currently"]?["apparentTemperature"] as! Int))
//                    let visibility = String(format: "%.1f",(dict["currently"]?["visibility"] as! Double))
//                    let windSpeed = String(format: "%.1f",(dict["currently"]?["windSpeed"] as! Double))
//func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
//    
//    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
//    
//    
//    if JSONSerialization.isValidJSONObject(value) {
//        
//        do{
//            let data = try JSONSerialization.data(withJSONObject: value, options: options)
//            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
//                return string as String
//            }
//        }catch {
//            
//            print("error")
//            //Access error here
//        }
//        
//    }
//    return ""
//    
//}
