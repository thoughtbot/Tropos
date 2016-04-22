import TroposCore
import CoreLocation
import Quick
import Nimble

private func weatherConditions(temperature temperature: Int = 90, precipitationProbability: String? = nil, precipitationType: String? = "rain") -> [String: AnyObject] {
    var data: [String: AnyObject] = [
        "temperatureMin": 50,
        "temperatureMax": 60,
    ]

    if let probability = precipitationProbability {
        data["precipProbability"] = probability
        if let type = precipitationType {
            data["precipType"] = type
        }
    }

    return [
        "currently": ["temperature": temperature],
        "daily": ["data": [data]],
    ]
}

final class WeatherUpdateSpec: QuickSpec {
    override func spec() {
        describe("TRWeatherUpdate") {
            context("currentTemp is higher than currentHigh") {
                it("updates currentHigh to match") {
                    let conditions = weatherConditions(temperature: 70)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: conditions, yesterdaysConditionsJSON: [:])
                    expect(update?.currentHigh.fahrenheitValue) == 70
                }

                it("updates currentLow to match") {
                    let conditions = weatherConditions(temperature: 40)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: conditions, yesterdaysConditionsJSON: [:])
                    expect(update?.currentLow.fahrenheitValue) == 40
                }
            }

            context("with a chance of precipitation") {
                it("stores the precipitation probability and type") {
                    let conditions = weatherConditions(precipitationProbability: "0.43")
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: conditions, yesterdaysConditionsJSON: [:])
                    let rawPercentage = update?.precipitationPercentage ?? 0
                    expect(round(rawPercentage * 100)) == 43
                }
            }

            context("with a no chance of precipitation") {
                it("stores the precipitation probability and defaults the type") {
                    let conditions = weatherConditions(precipitationProbability: "0", precipitationType: nil)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: conditions, yesterdaysConditionsJSON: [:])
                    expect(update?.precipitationPercentage) == 0
                    expect(update?.precipitationType) == "rain"
                }
            }
        }
    }
}
