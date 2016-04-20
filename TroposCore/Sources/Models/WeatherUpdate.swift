import CoreLocation
import Foundation

private let TRCurrentConditionsKey = "TRCurrentConditions"
private let TRYesterdaysConditionsKey = "TRYesterdaysConditions"
private let TRPlacemarkKey = "TRPlacemark"
private let TRDateKey = "TRDateAt"

@objc(TRWeatherUpdate) public final class WeatherUpdate: NSObject, NSCoding {
    public let date: NSDate
    public let placemark: CLPlacemark
    private let currentConditionsJSON: [String: AnyObject]
    private let yesterdaysConditionsJSON: [String: AnyObject]

    public init?(placemark: CLPlacemark, currentConditionsJSON: [String: AnyObject], yesterdaysConditionsJSON: [String: AnyObject], date: NSDate) {
        self.date = date
        self.placemark = placemark
        self.currentConditionsJSON = currentConditionsJSON
        self.yesterdaysConditionsJSON = yesterdaysConditionsJSON
        super.init()
    }

    public convenience init?(placemark: CLPlacemark, currentConditionsJSON: [String: AnyObject], yesterdaysConditionsJSON: [String: AnyObject]) {
        self.init(placemark: placemark, currentConditionsJSON: currentConditionsJSON, yesterdaysConditionsJSON: yesterdaysConditionsJSON, date: NSDate())
    }

    private lazy var currentConditions: [String: AnyObject] = {
        return self.currentConditionsJSON["currently"] as? [String: AnyObject] ?? [:]
    }()

    private lazy var forecasts: [[String: AnyObject]] = {
        return self.currentConditionsJSON["daily"]?["data"] as? [[String: AnyObject]] ?? []
    }()

    private var todaysForecast: [String: AnyObject] {
        return forecasts.first ?? [:]
    }

    public required init?(coder: NSCoder) {
        guard let currentConditions = coder.decodeObjectForKey(TRCurrentConditionsKey) as? [String: AnyObject],
            let yesterdaysConditions = coder.decodeObjectForKey(TRYesterdaysConditionsKey) as? [String: AnyObject],
            let placemark = coder.decodeObjectForKey(TRPlacemarkKey) as? CLPlacemark,
            let date = coder.decodeObjectForKey(TRDateKey) as? NSDate
            else {
                return nil
            }

        self.currentConditionsJSON = currentConditions
        self.yesterdaysConditionsJSON = yesterdaysConditions
        self.placemark = placemark
        self.date = date
    }

    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(currentConditionsJSON, forKey: TRCurrentConditionsKey)
        coder.encodeObject(yesterdaysConditionsJSON, forKey: TRYesterdaysConditionsKey)
        coder.encodeObject(placemark, forKey: TRPlacemarkKey)
        coder.encodeObject(date, forKey: TRDateKey)
    }
}

public extension WeatherUpdate {
    var city: String? {
        return placemark.locality
    }

    var state: String? {
        return placemark.administrativeArea
    }

    var conditionsDescription: String? {
        return currentConditions["icon"] as? String
    }

    var precipitationType: String {
        return (todaysForecast["precipType"] as? String) ?? "rain"
    }

    var currentTemperature: Temperature {
        let rawTemperature = self.currentConditions["temperature"] as? Int ?? 0
        return Temperature(fahrenheitValue: rawTemperature)
    }

    var currentHigh: Temperature {
        if case let rawHigh = todaysForecast["temperatureMax"] as? Int ?? 0 where rawHigh > currentTemperature.fahrenheitValue {
            return Temperature(fahrenheitValue: rawHigh)
        } else {
            return currentTemperature
        }
    }

    var currentLow: Temperature {
        if case let rawLow = todaysForecast["temperatureMin"] as? Int ?? 0 where rawLow < currentTemperature.fahrenheitValue {
            return Temperature(fahrenheitValue: rawLow)
        } else {
            return currentTemperature
        }
    }

    var yesterdaysTemperature: Temperature? {
        let rawTemperature = yesterdaysConditionsJSON["temperature"] as? Int ?? 0
        return Temperature(fahrenheitValue: rawTemperature)
    }

    var precipitationPercentage: Double {
        return Double(todaysForecast["precipProbability"] as? String ?? "") ?? 0
    }

    var windSpeed: Double {
        return currentConditions["windSpeed"] as? Double ?? 0
    }

    var windBearing: Double {
        return currentConditions["windBearing"] as? Double ?? 0
    }

    var dailyForecasts: [DailyForecast] {
        return (1...3).flatMap {
            if forecasts.indices.contains($0) {
                return DailyForecast(JSON: forecasts[$0])
            } else {
                return nil
            }
        }
    }
}
