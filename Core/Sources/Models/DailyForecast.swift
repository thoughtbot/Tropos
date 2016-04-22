import Foundation

public struct DailyForecast {
    public var date: NSDate
    public var conditionsDescription: String
    public var highTemperature: Temperature
    public var lowTemperature: Temperature

    public init?(JSON: AnyObject?) {
        guard let dict = JSON as? [String: AnyObject],
            let time = dict["time"] as? Double,
            let icon = dict["icon"] as? String,
            let temperatureMax = dict["temperatureMax"] as? Int,
            let temperatureMin = dict["temperatureMin"] as? Int
            else {
                return nil
            }

        self.date = NSDate(timeIntervalSince1970: time)
        self.conditionsDescription = icon
        self.highTemperature = Temperature(fahrenheitValue: temperatureMax)
        self.lowTemperature = Temperature(fahrenheitValue: temperatureMin)
    }
}
