import Foundation

public enum TemperatureComparison: String, CustomStringConvertible {
    case same, hotter, warmer, cooler, colder

    public var description: String {
        return rawValue
    }

    public var localizedAdjective: String {
        return TroposCoreLocalizedString(description)
    }
}

private enum TemperatureLimit: Int {
    case hotter = 32
    case colder = 75
}

func - (lhs: Temperature, rhs: Temperature) -> Temperature {
    return Temperature(fahrenheitValue: lhs.fahrenheitValue - rhs.fahrenheitValue)
}

@objc(TRTemperature) public class Temperature: NSObject {
    @objc public private(set) lazy var fahrenheitValue: Int = {
        Int(round(Float(self.celsiusValue) * 9.0 / 5.0)) + 32
    }()

    @objc public private(set) lazy var celsiusValue: Int = {
        Int(round(Float(self.fahrenheitValue - 32) * 5.0 / 9.0))
    }()

    @objc public init(fahrenheitValue: Int) {
        super.init()
        self.fahrenheitValue = fahrenheitValue
    }

    @objc public init(celsiusValue: Int) {
        super.init()
        self.celsiusValue = celsiusValue
    }

    @objc public func temperatureDifferenceFrom(_ temperature: Temperature) -> Temperature {
        return self - temperature
    }

    public func comparedTo(_ temperature: Temperature) -> TemperatureComparison {
        let diff = fahrenheitValue - temperature.fahrenheitValue
        switch diff {
        case _ where diff >= 10 && fahrenheitValue > TemperatureLimit.hotter.rawValue: return .hotter
        case _ where diff > 0: return .warmer
        case _ where diff == 0: return .same
        case _ where diff > -10 || fahrenheitValue > TemperatureLimit.colder.rawValue: return .cooler
        default: return .colder
        }
    }

    // MARK: NSObjectProtocol

    public override var description: String {
        return "Fahrenheit: \(fahrenheitValue)°\nCelsius: \(celsiusValue)°"
    }
}
