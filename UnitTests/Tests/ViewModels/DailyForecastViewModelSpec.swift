@testable import Tropos
import TroposCore
import Quick
import Nimble

final class DailyForecastViewModelSpec: QuickSpec {
    override func spec() {
        var testForecast: DailyForecast {
            return DailyForecast(JSON: [
                "time": NSDate(ISO8601String: "2016-04-18")!.timeIntervalSince1970,
                "icon": "clear-day",
                "temperatureMin": 50,
                "temperatureMax": 75,
            ])!
        }

        it("formats the day of week") {
            let viewModel = DailyForecastViewModel(dailyForecast: testForecast)
            expect(viewModel.dayOfWeek) == "Mon"
        }

        it("returns the expected icon image") {
            let viewModel = DailyForecastViewModel(dailyForecast: testForecast)
            expect(viewModel.conditionsImage) == UIImage(named: "clear-day")!
        }

        it("returns the formatted high temperature") {
            let formatter = TemperatureFormatter(unitSystem: .Imperial)
            let viewModel = DailyForecastViewModel(dailyForecast: testForecast, temperatureFormatter: formatter)
            expect(viewModel.highTemperature) == "75°"
        }

        it("returns the formatted low temperature") {
            let formatter = TemperatureFormatter(unitSystem: .Imperial)
            let viewModel = DailyForecastViewModel(dailyForecast: testForecast, temperatureFormatter: formatter)
            expect(viewModel.lowTemperature) == "50°"
        }
    }
}
