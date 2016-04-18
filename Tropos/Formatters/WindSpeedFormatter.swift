import Foundation

@objc(TRWindSpeedFormatter) final class WindSpeedFormatter: NSObject {
    var unitSystem: UnitSystem

    init(unitSystem: UnitSystem) {
        self.unitSystem = unitSystem
    }

    convenience override init() {
        self.init(unitSystem: SettingsController().unitSystem)
    }

    func localizedString(forWindSpeed windSpeed: Double, bearing: Double) -> String {
        guard let cardinalDirection = CardinalDirection(bearing: bearing) else {
            preconditionFailure("invalid bearing: \(bearing)")
        }

        let abbreviatedSpeedUnit: String
        let speed: Double

        if unitSystem == .Metric {
            if case "CA"? = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String {
                abbreviatedSpeedUnit = "km/h"
                speed = kilometersPerHourFromMilesPerHour(windSpeed)
            } else {
                abbreviatedSpeedUnit = "m/s"
                speed = metersPerSecondFromMilesPerHour(windSpeed)
            }
        } else {
            abbreviatedSpeedUnit = "mph"
            speed = windSpeed
        }

        return String(format: "%.0f %@ %@", speed, abbreviatedSpeedUnit, cardinalDirection.localizedAbbreviation)
    }

    private func kilometersPerHourFromMilesPerHour(mph: Double) -> Double {
        return mph * 1.60934
    }

    private func metersPerSecondFromMilesPerHour(mph: Double) -> Double {
        return mph * 0.44704
    }
}
