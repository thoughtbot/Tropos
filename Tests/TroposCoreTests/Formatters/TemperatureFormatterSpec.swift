import Nimble
import Quick
import TroposCore

final class TemperatureFormatterSpec: QuickSpec {
    override func spec() {
        it("can format fahrenheit temperatures in celsius") {
            let formatter = TemperatureFormatter(unitSystem: .metric)
            let temperature = Temperature(fahrenheitValue: 32)
            expect(formatter.stringFromTemperature(temperature)) == "0°"
        }

        it("can format celsius temperatures in fahrenheit") {
            let formatter = TemperatureFormatter(unitSystem: .imperial)
            let temperature = Temperature(celsiusValue: 0)
            expect(formatter.stringFromTemperature(temperature)) == "32°"
        }

        it("it fetches the unit system from the SettingsController by default") {
            SettingsController().unitSystem = .metric
            let formatter = TemperatureFormatter()
            let temperature = Temperature(fahrenheitValue: 32)
            expect(formatter.stringFromTemperature(temperature)) == "0°"
        }
    }
}
