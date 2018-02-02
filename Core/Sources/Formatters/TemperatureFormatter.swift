public struct TemperatureFormatter {
    public var unitSystem: UnitSystem

    public init(unitSystem: UnitSystem = SettingsController().unitSystem) {
        self.unitSystem = unitSystem
    }

    public func stringFromTemperature(_ temperature: Temperature) -> String {
        let usesMetricSystem = unitSystem == .metric
        let rawTemperature = usesMetricSystem ? temperature.celsiusValue : temperature.fahrenheitValue
        return String(format: "%.f°", Double(rawTemperature))
    }
}
