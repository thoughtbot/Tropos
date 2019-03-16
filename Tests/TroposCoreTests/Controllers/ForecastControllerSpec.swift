import Nimble
import OHHTTPStubs
import Quick
import TroposCore

final class ForecastControllerSpec: QuickSpec {
    override func spec() {
        describe("fetchWeatherUpdate") {
            beforeEach(handleUnexpectedNetworkRequests)
            afterEach(OHHTTPStubs.removeAllStubs)

            it("fetches weather from api.forecast.io") {
                expect {
                    ForecastController(apiKey: "test").fetchWeatherUpdate(for: testPlacemark)
                }.toEventually(
                    makeNetworkRequest(matching: .scheme("https") && .host("api.forecast.io"))
                )
            }

            it("requests today and yesterday's forecasts with the correct API key and location") {
                expect {
                    ForecastController(apiKey: "correct-key").fetchWeatherUpdate(for: testPlacemark)
                }.toEventually(
                    satisfyAllOf(
                        makeNetworkRequest(matching: .path("/forecast/correct-key/40.759069,-73.984961")),
                        makeNetworkRequest(matching: .path(regex: "^/forecast/correct-key/40.759069,-73.984961,"))
                    )
                )
            }
        }
    }
}
