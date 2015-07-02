import Foundation

@objc class DailyForecast: NSObject, NSCoding {
    let date: NSDate
    let conditionsDescription: String
    let highTemperature: Temperature
    let lowTemperature: Temperature
    
    convenience init(json: NSDictionary) {
        let date = NSDate(timeIntervalSince1970: json["time"] as! NSTimeInterval)
        let conditionsDescription = json["icon"] as! String
        let highTemperature = Temperature(fahrenheitValue: json["temperatureMax"] as! Int)
        let lowTemperature = Temperature(fahrenheitValue: json["temperatureMin"] as! Int)
        self.init(date: date, conditionsDescription: conditionsDescription, highTemperature: highTemperature, lowTemperature: lowTemperature)
    }
    
    init(date: NSDate, conditionsDescription: String, highTemperature: Temperature, lowTemperature: Temperature) {
        self.date = date
        self.conditionsDescription = conditionsDescription
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
    }
    
    // MARK: NSCoding
    enum NSCodingKey: String {
        case Date = "date"
        case ConditionsDescription = "conditionsDescription"
        case HighTemperature = "highTemperature"
        case LowTemperature = "lowTemperature"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: NSCodingKey.Date.rawValue)
        aCoder.encodeObject(conditionsDescription, forKey: NSCodingKey.ConditionsDescription.rawValue)
        aCoder.encodeObject(highTemperature, forKey: NSCodingKey.HighTemperature.rawValue)
        aCoder.encodeObject(lowTemperature, forKey: NSCodingKey.LowTemperature.rawValue)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(NSCodingKey.Date.rawValue) as! NSDate
        let conditionsDescription = aDecoder.decodeObjectForKey(NSCodingKey.ConditionsDescription.rawValue) as! String
        let highTemperature = aDecoder.decodeObjectForKey(NSCodingKey.HighTemperature.rawValue) as! Temperature
        let lowTemperature = aDecoder.decodeObjectForKey(NSCodingKey.LowTemperature.rawValue) as! Temperature
        self.init(date: date, conditionsDescription: conditionsDescription, highTemperature: highTemperature, lowTemperature: lowTemperature)
    }
}