import Foundation

struct DailyForecast {
    var date: NSDate
    var conditionsDescription: String
    var highTemperature: Temperature
    var lowTemperature: Temperature

    init?(JSON: AnyObject?) {
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
