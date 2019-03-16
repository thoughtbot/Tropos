import CoreLocation
import Nimble
import Quick
import TroposCore

private func weatherConditions(
    _ temperature: Int = 90,
    precipitationProbability: Double? = nil,
    precipitationType: String? = "rain"
) -> [String: Any] {
    var data: [String: Any] = [
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
                    let conditions = weatherConditions(70)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: conditions,
                        yesterdaysConditionsJSON: [:]
                    )
                    expect(update.currentHigh.fahrenheitValue) == 70
                }

                it("updates currentLow to match") {
                    let conditions = weatherConditions(40)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: conditions,
                        yesterdaysConditionsJSON: [:]
                    )
                    expect(update.currentLow.fahrenheitValue) == 40
                }
            }

            context("with a chance of precipitation") {
                it("stores the precipitation probability and type") {
                    let conditions = weatherConditions(precipitationProbability: 0.43)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: conditions,
                        yesterdaysConditionsJSON: [:]
                    )
                    expect(round(update.precipitationPercentage * 100)) == 43
                }
            }

            context("with a no chance of precipitation") {
                it("stores the precipitation probability and defaults the type") {
                    let conditions = weatherConditions(precipitationProbability: 0, precipitationType: nil)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: conditions,
                        yesterdaysConditionsJSON: [:]
                    )
                    expect(update.precipitationPercentage) == 0
                    expect(update.precipitationType) == "rain"
                }
            }
        }

        describe("yesterdaysTemperature") {
            it("returns yesterday's temperature") {
                let yesterdaysConditions = weatherConditions(70)
                let update = WeatherUpdate(
                    placemark: testPlacemark,
                    currentConditionsJSON: [:],
                    yesterdaysConditionsJSON: yesterdaysConditions
                )
                expect(update.yesterdaysTemperature?.fahrenheitValue) == 70
            }

            it("returns .None if yesterday's temperature is unavailable") {
                let update = WeatherUpdate(
                    placemark: testPlacemark,
                    currentConditionsJSON: [:],
                    yesterdaysConditionsJSON: [:]
                )
                expect(update.yesterdaysTemperature?.fahrenheitValue).to(beNil())
            }
        }
    }
}
