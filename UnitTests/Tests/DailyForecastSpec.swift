import Foundation
import Quick
import Nimble

class DailyForecastSpec: QuickSpec {
    override func spec() {
        describe("DailyForecast") {
            context("should correctly initialize set properties") {
                let json = ["time": Double(20.0), "icon": "text", "temperatureMax": 50, "temperatureMin": 10]
                let dailyForecast = DailyForecast(json: json)
                
                expect(dailyForecast.date).to(equal(NSDate(timeIntervalSince1970: 20)))
                expect(dailyForecast.conditionsDescription).to(equal("text"))
                expect(dailyForecast.highTemperature.fahrenheitValue).to(equal(50))
                expect(dailyForecast.lowTemperature.fahrenheitValue).to(equal(10))
            }
        }
    }
}