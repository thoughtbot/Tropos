import UIKit

@objc(TRWeatherViewModel) public final class WeatherViewModel: NSObject {
    fileprivate let weatherUpdate: WeatherUpdate
    fileprivate let dateFormatter: RelativeDateFormatter

    public init(weatherUpdate: WeatherUpdate, dateFormatter: RelativeDateFormatter) {
        self.weatherUpdate = weatherUpdate
        self.dateFormatter = dateFormatter
    }

    @objc public convenience init(weatherUpdate: WeatherUpdate) {
        self.init(weatherUpdate: weatherUpdate, dateFormatter: RelativeDateFormatter())
    }
}

public extension WeatherViewModel {
    @objc var locationName: String {
        return [weatherUpdate.city, weatherUpdate.state].lazy
            .compactMap { $0 }
            .joined(separator: ", ")
    }

    @objc var updatedDateString: String {
        return dateFormatter.localizedStringFromDate(weatherUpdate.date)
    }

    @objc var conditionsImage: UIImage? {
        return weatherUpdate.conditionsDescription.flatMap {
            UIImage(named: $0, in: .troposBundle, compatibleWith: nil)
        }
    }

    @objc var conditionsDescription: NSAttributedString {
        let comparison = weatherUpdate.currentTemperature.comparedTo(weatherUpdate.yesterdaysTemperature!)

        let (description, adjective) = TemperatureComparisonFormatter().localizedStrings(
            fromComparison: comparison,
            precipitation: precipitationDescription,
            date: weatherUpdate.date
        )

        let attributedString = NSMutableAttributedString(string: description)
        attributedString.font = .defaultLightFont(size: 26)
        attributedString.textColor = .defaultTextColor

        let difference = weatherUpdate.currentTemperature
            .temperatureDifferenceFrom(weatherUpdate.yesterdaysTemperature!)
        attributedString.setTextColor(
            colorForTemperatureComparison(comparison, difference: difference.fahrenheitValue),
            forSubstring: adjective
        )
        return attributedString.copy() as! NSAttributedString
    }

    @objc var windDescription: String {
        return WindSpeedFormatter().localizedString(
            forWindSpeed: weatherUpdate.windSpeed,
            bearing: weatherUpdate.windBearing
        )
    }

    @objc var precipitationDescription: String {
        let precipitation = Precipitation(
            probability: weatherUpdate.precipitationPercentage,
            type: weatherUpdate.precipitationType
        )
        return PrecipitationChanceFormatter().localizedStringFromPrecipitation(precipitation)
    }

    @objc var temperatureDescription: NSAttributedString {
        let formatter = TemperatureFormatter()
        let temperatures = [weatherUpdate.currentHigh, weatherUpdate.currentTemperature, weatherUpdate.currentLow]
        let temperatureString = temperatures.lazy.map(formatter.stringFromTemperature).joined(separator: " / ")

        let attributedString = NSMutableAttributedString(string: temperatureString)
        let comparison = weatherUpdate.currentTemperature.comparedTo(weatherUpdate.yesterdaysTemperature!)
        let difference = weatherUpdate.currentTemperature
            .temperatureDifferenceFrom(weatherUpdate.yesterdaysTemperature!)

        let rangeOfFirstSlash = (temperatureString as NSString).range(of: "/")
        let rangeOfLastSlash = (temperatureString as NSString).range(of: "/", options: .backwards)
        let start = (rangeOfFirstSlash.location + 1)
        let range = NSRange(location: start, length: rangeOfLastSlash.location - start)
        attributedString.setTextColor(
            colorForTemperatureComparison(comparison, difference: difference.fahrenheitValue),
            forRange: range
        )

        return attributedString.copy() as! NSAttributedString
    }

    @objc var dailyForecasts: [DailyForecastViewModel] {
        return weatherUpdate.dailyForecasts.map(DailyForecastViewModel.init)
    }
}

private extension WeatherViewModel {
    func colorForTemperatureComparison(_ comparison: TemperatureComparison, difference: Int) -> UIColor {
        let color: UIColor

        switch comparison {
        case .same:
            color = .defaultTextColor
        case .colder:
            color = .coldColor
        case .cooler:
            color = .coolerColor
        case .hotter:
            color = .hotColor
        case .warmer:
            color = .warmerColor
        }

        if comparison == .cooler || comparison == .warmer {
            let amount = CGFloat(min(abs(difference), 10)) / 10.0
            let lighterAmount = min(1 - amount, 0.8)
            return color.lighten(by: lighterAmount)
        } else {
            return color
        }
    }
}
