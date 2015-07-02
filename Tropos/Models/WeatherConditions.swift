import Foundation

@objc class WeatherConditions: NSObject, NSCoding {
    let current: CurrentConditions
    let yesterday: YesterdaysConditions
    
    convenience init(currentConditionsJSON: Dictionary<String, AnyObject>, yesterdaysConditionsJSON: Dictionary<String, AnyObject>) {
        let temperatureValue = yesterdaysConditionsJSON["currently"]!["temperature"] as! Int
        let yesterday = YesterdaysConditions(temperature: temperatureValue)
        let current = CurrentConditions(json: currentConditionsJSON)
        self.init(current: current, yesterday: yesterday)
    }
    
    init(current: CurrentConditions, yesterday: YesterdaysConditions) {
        self.current = current
        self.yesterday = yesterday
    }
    
    // NSCoding
    enum NSCodingKey: String {
        case Current = "Current"
        case Yesterday = "Yesterday"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(current, forKey: NSCodingKey.Current.rawValue)
        aCoder.encodeObject(yesterday, forKey: NSCodingKey.Yesterday.rawValue)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        let current = aDecoder.decodeObjectForKey(NSCodingKey.Current.rawValue) as! CurrentConditions
        let yesterday = aDecoder.decodeObjectForKey(NSCodingKey.Yesterday.rawValue) as! YesterdaysConditions
        self.init(current:current, yesterday: yesterday)
    }
}
