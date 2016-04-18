import UIKit

@objc(TRDailyForecastViewModel) final class DailyForecastViewModel: NSObject {
    private let dailyForecast: DailyForecast
    private let temperatureFormatter: TemperatureFormatter

    init(dailyForecast: DailyForecast, temperatureFormatter: TemperatureFormatter) {
        self.dailyForecast = dailyForecast
        self.temperatureFormatter = temperatureFormatter
    }

    convenience init(dailyForecast: DailyForecast) {
        self.init(dailyForecast: dailyForecast, temperatureFormatter: TemperatureFormatter())
    }

    var dayOfWeek: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ccc"
        return formatter.stringFromDate(dailyForecast.date)
    }

    var conditionsImage: UIImage? {
        return UIImage(named: dailyForecast.conditionsDescription)
    }

    var highTemperature: String {
        return temperatureFormatter.stringFromTemperature(dailyForecast.highTemperature)
    }

    var lowTemperature: String {
        return temperatureFormatter.stringFromTemperature(dailyForecast.lowTemperature)
    }
}
