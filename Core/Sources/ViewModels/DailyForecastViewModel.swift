import UIKit

@objc(TRDailyForecastViewModel) public final class DailyForecastViewModel: NSObject {
    fileprivate let dailyForecast: DailyForecast
    fileprivate let temperatureFormatter: TemperatureFormatter

    public init(dailyForecast: DailyForecast, temperatureFormatter: TemperatureFormatter) {
        self.dailyForecast = dailyForecast
        self.temperatureFormatter = temperatureFormatter
    }

    public convenience init(dailyForecast: DailyForecast) {
        self.init(dailyForecast: dailyForecast, temperatureFormatter: TemperatureFormatter())
    }
}

public extension DailyForecastViewModel {
    @objc var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ccc"
        return formatter.string(from: dailyForecast.date)
    }

    @objc var conditionsImage: UIImage? {
        return UIImage(named: dailyForecast.conditionsDescription, in: .troposBundle, compatibleWith: nil)
    }

    @objc var highTemperature: String {
        return temperatureFormatter.stringFromTemperature(dailyForecast.highTemperature)
    }

    @objc var lowTemperature: String {
        return temperatureFormatter.stringFromTemperature(dailyForecast.lowTemperature)
    }
}
