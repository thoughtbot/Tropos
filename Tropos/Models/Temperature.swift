import Foundation

enum TemperatureComparison {
    case Same, Hotter, Warmer, Cooler, Colder
}

private enum TemperatureLimit: Int {
    case Hotter = 32
    case Colder = 75
}

func -(lhs: Temperature, rhs: Temperature) -> Temperature {
    return Temperature(fahrenheitValue: lhs.fahrenheitValue - rhs.fahrenheitValue)
}

@objc(TRTemperature) class Temperature: NSObject {
    lazy private(set) var fahrenheitValue: Int = {
        return Int(round(Float(self.celsiusValue) * 9.0 / 5.0)) + 32
    }()

    lazy private(set) var celsiusValue: Int = {
        return Int(round(Float(self.fahrenheitValue - 32) * 5.0 / 9.0))
    }()

    init(fahrenheitValue: Int) {
        super.init()
        self.fahrenheitValue = fahrenheitValue
    }

    init(celsiusValue: Int) {
        super.init()
        self.celsiusValue = celsiusValue
    }
    
    func temperatureDifferenceFrom(temperature: Temperature) -> Temperature {
        return self - temperature
    }

    func comparedTo(temperature: Temperature) -> TemperatureComparison {
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
    override var description: String {
        return "Fahrenheit: \(fahrenheitValue)°\nCelsius: \(celsiusValue)°"
    }
}

extension TemperatureComparison {
    var localizedAdjective: String {
        switch self {
        case .Hotter:
            return NSLocalizedString("Hotter", comment: "")
        case .Warmer:
            return NSLocalizedString("Warmer", comment: "")
        case .Cooler:
            return NSLocalizedString("Cooler", comment: "")
        case .Colder:
            return NSLocalizedString("Colder", comment: "")
        case .Same:
            return NSLocalizedString("Same", comment: "")
        }
    }
}
