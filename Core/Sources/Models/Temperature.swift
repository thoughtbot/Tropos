import Foundation

public enum TemperatureComparison: String, CustomStringConvertible {
    case Same, Hotter, Warmer, Cooler, Colder

    public var description: String {
        return rawValue
    }

    public var localizedAdjective: String {
        return TroposCoreLocalizedString(description)
    }
}

private enum TemperatureLimit: Int {
    case Hotter = 32
    case Colder = 75
}

func -(lhs: Temperature, rhs: Temperature) -> Temperature {
    return Temperature(fahrenheitValue: lhs.fahrenheitValue - rhs.fahrenheitValue)
}

@objc(TRTemperature) public class Temperature: NSObject {
    public private(set) lazy var fahrenheitValue: Int = {
        return Int(round(Float(self.celsiusValue) * 9.0 / 5.0)) + 32
    }()

    public private(set) lazy var celsiusValue: Int = {
        return Int(round(Float(self.fahrenheitValue - 32) * 5.0 / 9.0))
    }()

    public init(fahrenheitValue: Int) {
        super.init()
        self.fahrenheitValue = fahrenheitValue
    }

    public init(celsiusValue: Int) {
        super.init()
        self.celsiusValue = celsiusValue
    }
    
    public func temperatureDifferenceFrom(temperature: Temperature) -> Temperature {
        return self - temperature
    }

    public func comparedTo(temperature: Temperature) -> TemperatureComparison {
        let diff = fahrenheitValue - temperature.fahrenheitValue
        switch diff {
        case _ where diff >= 10 && fahrenheitValue > TemperatureLimit.Hotter.rawValue: return .Hotter
        case _ where diff > 0: return .Warmer
        case _ where diff == 0: return .Same
        case _ where diff > -10 || fahrenheitValue > TemperatureLimit.Colder.rawValue: return .Cooler
        default: return .Colder
        }
    }
    
    // MARK: NSObjectProtocol
    public override var description: String {
        return "Fahrenheit: \(fahrenheitValue)°\nCelsius: \(celsiusValue)°"
    }
}
