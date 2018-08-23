import Foundation
import TroposCore

@available(iOS 12.0, *)
public final class CheckWeatherIntentHandler: NSObject, CheckWeatherIntentHandling {
    public func handle(intent: CheckWeatherIntent, completion: @escaping (CheckWeatherIntentResponse) -> Void) {
        let cache = WeatherUpdateCache(fileName: WeatherUpdateCache.latestWeatherUpdateFileName)
        let response: CheckWeatherIntentResponse
        defer { completion(response) }

        if let weatherUpdate = cache?.latestWeatherUpdate {
            let viewModel = WeatherViewModel(weatherUpdate: weatherUpdate)
            response = CheckWeatherIntentResponse.success(conditionsDescription: viewModel.conditionsDescription.string)
        } else {
            response = CheckWeatherIntentResponse(code: .failure, userActivity: nil)
        }
    }
}
