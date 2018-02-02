import Foundation

public struct WindSpeedFormatter {
    public var unitSystem: UnitSystem

    public init(unitSystem: UnitSystem = SettingsController().unitSystem) {
        self.unitSystem = unitSystem
    }

    public func localizedString(forWindSpeed windSpeed: Double, bearing: Double) -> String {
        guard let cardinalDirection = CardinalDirection(bearing: bearing) else {
            preconditionFailure("invalid bearing: \(bearing)")
        }

        let abbreviatedSpeedUnit: String
        let speed: Double

        if unitSystem == .metric {
            if Locale.current.regionCode == "CA" {
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

    private func kilometersPerHourFromMilesPerHour(_ mph: Double) -> Double {
        return mph * 1.60934
    }

    private func metersPerSecondFromMilesPerHour(_ mph: Double) -> Double {
        return mph * 0.44704
    }
}
