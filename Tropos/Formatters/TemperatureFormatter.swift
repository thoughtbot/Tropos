@objc(TRTemperatureFormatter) final class TemperatureFormatter: NSObject {
    var unitSystem: UnitSystem

    init(unitSystem: UnitSystem) {
        self.unitSystem = unitSystem
        super.init()
    }

    convenience override init() {
        self.init(unitSystem: SettingsController().unitSystem)
    }

    func stringFromTemperature(temperature: Temperature) -> String {
        let usesMetricSystem = unitSystem == .Metric
        let rawTemperature = usesMetricSystem ? temperature.celsiusValue : temperature.fahrenheitValue
        return String(format: "%.f°", Double(rawTemperature))
    }
}
