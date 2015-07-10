import Foundation

@objc final class DailyForecast: NSObject {
    let date: NSDate
    let conditionsDescription: String
    let highTemperature: Temperature
    let lowTemperature: Temperature
    
    init(JSON: Dictionary<String, AnyObject>) {
        self.date = NSDate(timeIntervalSince1970: JSON["time"] as! NSTimeInterval)
        self.conditionsDescription = JSON["icon"] as! String
        self.highTemperature = Temperature(fahrenheitValue: JSON["temperatureMax"] as! Int)
        self.lowTemperature = Temperature(fahrenheitValue: JSON["temperatureMin"] as! Int)
    }
}
