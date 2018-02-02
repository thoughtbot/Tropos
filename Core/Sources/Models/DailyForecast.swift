import Foundation

public struct DailyForecast {
    public var date: Date
    public var conditionsDescription: String
    public var highTemperature: Temperature
    public var lowTemperature: Temperature

    public init?(JSON: Any?) {
        guard let dict = JSON as? [String: Any],
            let time = dict["time"] as? Double,
            let icon = dict["icon"] as? String,
            let temperatureMax = dict["temperatureMax"] as? Int,
            let temperatureMin = dict["temperatureMin"] as? Int
            else {
                return nil
            }

        self.date = Date(timeIntervalSince1970: time)
        self.conditionsDescription = icon
        self.highTemperature = Temperature(fahrenheitValue: temperatureMax)
        self.lowTemperature = Temperature(fahrenheitValue: temperatureMin)
    }
}
