import Foundation

public struct DailyForecast {
    public var date: Date
    public var conditionsDescription: String
    public var highTemperature: Temperature
    public var lowTemperature: Temperature

    public init?(json: [String: Any]?) {
        guard let json = json,
            let time = json["time"] as? Double,
            let icon = json["icon"] as? String,
            let temperatureMax = json["temperatureMax"] as? Int,
            let temperatureMin = json["temperatureMin"] as? Int
            else {
                return nil
            }

        self.date = Date(timeIntervalSince1970: time)
        self.conditionsDescription = icon
        self.highTemperature = Temperature(fahrenheitValue: temperatureMax)
        self.lowTemperature = Temperature(fahrenheitValue: temperatureMin)
    }
}
