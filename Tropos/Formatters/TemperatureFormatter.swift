struct TemperatureFormatter {
    var unitSystem: UnitSystem

    init(unitSystem: UnitSystem = SettingsController().unitSystem) {
        self.unitSystem = unitSystem
    }

    func stringFromTemperature(temperature: Temperature) -> String {
        let usesMetricSystem = unitSystem == .Metric
        let rawTemperature = usesMetricSystem ? temperature.celsiusValue : temperature.fahrenheitValue
        return String(format: "%.f°", Double(rawTemperature))
    }
}
