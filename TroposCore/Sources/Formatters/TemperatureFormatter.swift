public struct TemperatureFormatter {
    public var unitSystem: UnitSystem

    public init(unitSystem: UnitSystem = SettingsController().unitSystem) {
        self.unitSystem = unitSystem
    }

    public func stringFromTemperature(temperature: Temperature) -> String {
        let usesMetricSystem = unitSystem == .Metric
        let rawTemperature = usesMetricSystem ? temperature.celsiusValue : temperature.fahrenheitValue
        return String(format: "%.f°", Double(rawTemperature))
    }
}
