import CoreLocation
import Foundation

private let TRCurrentConditionsKey = "TRCurrentConditions"
private let TRYesterdaysConditionsKey = "TRYesterdaysConditions"
private let TRPlacemarkKey = "TRPlacemark"
private let TRDateKey = "TRDateAt"

@objc(TRWeatherUpdate) public final class WeatherUpdate: NSObject, NSCoding {
    @objc public let date: Date
    @objc public let placemark: CLPlacemark
    private let currentConditionsJSON: [String: Any]
    fileprivate let yesterdaysConditionsJSON: [String: Any]

    @objc public init(
        placemark: CLPlacemark,
        currentConditionsJSON: [String: Any],
        yesterdaysConditionsJSON: [String: Any],
        date: Date
    ) {
        self.date = date
        self.placemark = placemark
        self.currentConditionsJSON = currentConditionsJSON
        self.yesterdaysConditionsJSON = yesterdaysConditionsJSON
        super.init()
    }

    @objc public convenience init(
        placemark: CLPlacemark,
        currentConditionsJSON: [String: Any],
        yesterdaysConditionsJSON: [String: Any]
    ) {
        self.init(
            placemark: placemark,
            currentConditionsJSON: currentConditionsJSON,
            yesterdaysConditionsJSON: yesterdaysConditionsJSON,
            date: Date()
        )
    }

    fileprivate lazy var currentConditions: [String: Any] = {
        self.currentConditionsJSON["currently"] as? [String: Any] ?? [:]
    }()

    fileprivate lazy var forecasts: [[String: Any]] = {
        let daily = self.currentConditionsJSON["daily"] as? [String: Any]
        return daily?["data"] as? [[String: Any]] ?? []
    }()

    fileprivate var todaysForecast: [String: Any] {
        return forecasts.first ?? [:]
    }

    public required init?(coder: NSCoder) {
        guard let currentConditions = coder.decodeObject(forKey: TRCurrentConditionsKey) as? [String: Any],
            let yesterdaysConditions = coder.decodeObject(forKey: TRYesterdaysConditionsKey) as? [String: Any],
            let placemark = coder.decodeObject(forKey: TRPlacemarkKey) as? CLPlacemark,
            let date = coder.decodeObject(forKey: TRDateKey) as? Date
        else {
            return nil
        }

        self.currentConditionsJSON = currentConditions
        self.yesterdaysConditionsJSON = yesterdaysConditions
        self.placemark = placemark
        self.date = date
    }

    public func encode(with coder: NSCoder) {
        coder.encode(currentConditionsJSON, forKey: TRCurrentConditionsKey)
        coder.encode(yesterdaysConditionsJSON, forKey: TRYesterdaysConditionsKey)
        coder.encode(placemark, forKey: TRPlacemarkKey)
        coder.encode(date, forKey: TRDateKey)
    }
}

public extension WeatherUpdate {
    @objc var city: String? {
        return placemark.locality
    }

    @objc var state: String? {
        return placemark.administrativeArea
    }

    @objc var conditionsDescription: String? {
        return currentConditions["icon"] as? String
    }

    @objc var precipitationType: String {
        return (todaysForecast["precipType"] as? String) ?? "rain"
    }

    @objc var currentTemperature: Temperature {
        let rawTemperature = (currentConditions["temperature"] as? NSNumber)?.intValue ?? 0
        return Temperature(fahrenheitValue: rawTemperature)
    }

    @objc var currentHigh: Temperature {
        let rawHigh = (todaysForecast["temperatureMax"] as? NSNumber)?.intValue ?? 0

        if rawHigh > currentTemperature.fahrenheitValue {
            return Temperature(fahrenheitValue: rawHigh)
        } else {
            return currentTemperature
        }
    }

    @objc var currentLow: Temperature {
        let rawLow = (todaysForecast["temperatureMin"] as? NSNumber)?.intValue ?? 0

        if rawLow < currentTemperature.fahrenheitValue {
            return Temperature(fahrenheitValue: rawLow)
        } else {
            return currentTemperature
        }
    }

    @objc var yesterdaysTemperature: Temperature? {
        let currently = yesterdaysConditionsJSON["currently"] as? [String: Any]
        let rawTemperature = currently?["temperature"] as? NSNumber
        guard let fahrenheitValue = rawTemperature?.intValue else {
            return .none
        }
        return Temperature(fahrenheitValue: fahrenheitValue)
    }

    @objc var precipitationPercentage: Double {
        return (todaysForecast["precipProbability"] as? NSNumber)?.doubleValue ?? 0
    }

    @objc var windSpeed: Double {
        return (currentConditions["windSpeed"] as? NSNumber)?.doubleValue ?? 0
    }

    @objc var windBearing: Double {
        return (currentConditions["windBearing"] as? NSNumber)?.doubleValue ?? 0
    }

    var dailyForecasts: [DailyForecast] {
        return (1 ... 3).compactMap {
            if forecasts.indices.contains($0) {
                return DailyForecast(json: forecasts[$0])
            } else {
                return nil
            }
        }
    }
}
