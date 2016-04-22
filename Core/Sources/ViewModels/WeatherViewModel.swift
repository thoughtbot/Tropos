import UIKit

@objc(TRWeatherViewModel) public final class WeatherViewModel: NSObject {
    private let weatherUpdate: WeatherUpdate
    private let dateFormatter: RelativeDateFormatter

    public init(weatherUpdate: WeatherUpdate, dateFormatter: RelativeDateFormatter) {
        self.weatherUpdate = weatherUpdate
        self.dateFormatter = dateFormatter
    }

    public convenience init(weatherUpdate: WeatherUpdate) {
        self.init(weatherUpdate: weatherUpdate, dateFormatter: RelativeDateFormatter())
    }
}

public extension WeatherViewModel {
    var locationName: String {
        return [weatherUpdate.city, weatherUpdate.state].lazy
            .flatMap { $0 }
            .joinWithSeparator(", ")
    }

    var updatedDateString: String {
        return dateFormatter.localizedStringFromDate(weatherUpdate.date)
    }

    var conditionsImage: UIImage? {
        return weatherUpdate.conditionsDescription.flatMap { UIImage(named: $0, inBundle: .troposBundle, compatibleWithTraitCollection: nil) }
    }

    var conditionsDescription: NSAttributedString {
        let comparison = weatherUpdate.currentTemperature.comparedTo(weatherUpdate.yesterdaysTemperature!)

        let (description, adjective) = TemperatureComparisonFormatter().localizedStrings(
            fromComparison: comparison,
            precipitation: precipitationDescription,
            date: weatherUpdate.date
        )

        let attributedString = NSMutableAttributedString(string: description)
        attributedString.font = .defaultUltraLightFont(size: 26)
        attributedString.textColor = .defaultTextColor

        let difference = weatherUpdate.currentTemperature.temperatureDifferenceFrom(weatherUpdate.yesterdaysTemperature!)
        attributedString.setTextColor(colorForTemperatureComparison(comparison, difference: difference.fahrenheitValue), forSubstring: adjective)

        return attributedString.copy() as! NSAttributedString
    }

    var windDescription: String {
        return WindSpeedFormatter().localizedString(forWindSpeed: weatherUpdate.windSpeed, bearing: weatherUpdate.windBearing)
    }

    var precipitationDescription: String {
        let precipitation = Precipitation(probability: weatherUpdate.precipitationPercentage, type: weatherUpdate.precipitationType)
        return PrecipitationChanceFormatter().localizedStringFromPrecipitation(precipitation)
    }

    var temperatureDescription: NSAttributedString {
        let formatter = TemperatureFormatter()
        let temperatures = [weatherUpdate.currentHigh, weatherUpdate.currentTemperature, weatherUpdate.currentLow]
        let temperatureString = temperatures.lazy.map(formatter.stringFromTemperature).joinWithSeparator(" / ")

        let attributedString = NSMutableAttributedString(string: temperatureString)
        let comparison = weatherUpdate.currentTemperature.comparedTo(weatherUpdate.yesterdaysTemperature!)
        let difference = weatherUpdate.currentTemperature.temperatureDifferenceFrom(weatherUpdate.yesterdaysTemperature!)

        let rangeOfFirstSlash = (temperatureString as NSString).rangeOfString("/")
        let rangeOfLastSlash = (temperatureString as NSString).rangeOfString("/", options: .BackwardsSearch)
        let start = rangeOfFirstSlash.location.successor()
        let range = NSRange(location: start, length: rangeOfLastSlash.location - start)
        attributedString.setTextColor(colorForTemperatureComparison(comparison, difference: difference.fahrenheitValue), forRange: range)

        return attributedString.copy() as! NSAttributedString
    }

    var dailyForecasts: [DailyForecastViewModel] {
        return weatherUpdate.dailyForecasts.map(DailyForecastViewModel.init)
    }
}

private extension WeatherViewModel {
    func colorForTemperatureComparison(comparison: TemperatureComparison, difference: Int) -> UIColor {
        let color: UIColor

        switch comparison {
        case .Same:
            color = .defaultTextColor
        case .Colder:
            color = .coldColor
        case .Cooler:
            color = .coolerColor
        case .Hotter:
            color = .hotColor
        case .Warmer:
            color = .warmerColor
        }

        if comparison == .Cooler || comparison == .Warmer {
            let amount = CGFloat(min(abs(difference), 10)) / 10.0
            let lighterAmount = min(1 - amount, 0.8)
            return color.lighten(by: lighterAmount)
        } else {
            return color
        }
    }
}
