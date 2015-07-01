import Foundation

@objc enum TemperatureComparison: Int {
    case Same, Hotter, Warmer, Cooler, Colder
}

private enum TemperatureLimit: Int {
    case Hotter = 32
    case Colder = 75
}

@objc class Temperature: NSObject {
    let fahrenheitValue: Int
    
    lazy var celsiusValue: Int = {
        return Int(round(Float(self.fahrenheitValue - 32) * 5.0 / 9.0))
    }()
    
    init(fahrenheitValue: Int) {
        self.fahrenheitValue = fahrenheitValue
    }
    
    func temperatureDifferenceFrom(temperature: Temperature) -> Temperature {
        return Temperature(fahrenheitValue: fahrenheitDifference(temperature))
    }

    func comparedTo(temperature: Temperature) -> TemperatureComparison {
        let diff = fahrenheitDifference(temperature)
        switch diff {
        case _ where diff >= 10 && fahrenheitValue > TemperatureLimit.Hotter.rawValue: return .Hotter
        case _ where diff > 0: return .Warmer
        case _ where diff == 0: return .Same
        case _ where diff > -10 || fahrenheitValue > TemperatureLimit.Colder.rawValue: return .Cooler
        default: return .Colder
        }
    }
    
    private func fahrenheitDifference(temperature: Temperature) -> Int {
        return fahrenheitValue - temperature.fahrenheitValue
    }
    
    // MARK: NSObjectProtocol
    override var description: String {
        return "Fahrenheit: \(fahrenheitValue)°\nCelsius: \(celsiusValue)°"
    }
}