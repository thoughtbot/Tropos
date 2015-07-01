import Foundation

@objc class DailyForecast: NSObject {
    let date: NSDate
    let conditionsDescription: String
    let highTemperature: Temperature
    let lowTemperature: Temperature
    
    init(json: NSDictionary) {
        self.date = NSDate(timeIntervalSince1970: json["time"] as! NSTimeInterval)
        self.conditionsDescription = json["icon"] as! String
        self.highTemperature = Temperature(fahrenheitValue: json["temperatureMax"] as! Int)
        self.lowTemperature = Temperature(fahrenheitValue: json["temperatureMin"] as! Int)
    }
}