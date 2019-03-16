import Foundation
import os.log
import ReactiveSwift
import Result
import TroposCore

@available(iOS 12.0, *)
public final class CheckWeatherIntentHandler: NSObject, CheckWeatherIntentHandling {
    public func handle(intent: CheckWeatherIntent, completion: @escaping (CheckWeatherIntentResponse) -> Void) {
        DispatchQueue.main.async {
            self.updateWeather(completion: completion)
        }
    }

    func updateWeather(completion: @escaping (CheckWeatherIntentResponse) -> Void) {
        let forecast = ForecastController(apiKey: TRForecastAPIKey)
        let geocode = GeocodeController()
        let location = LocationController()

        let weatherUpdate = location.requestAuthorization()
            .flatMap(.latest) { _ in location.requestLocation() }
            .flatMap(.latest) { location in geocode.reverseGeocode(location) }
            .mapError(AnyError.init)
            .flatMap(.latest) { placemark in forecast.fetchWeatherUpdate(for: placemark) }

        weatherUpdate.startWithResult { result in
            switch result {
            case let .success(weatherUpdate):
                self.cacheWeatherUpdate(weatherUpdate) {
                    let viewModel = WeatherViewModel(weatherUpdate: weatherUpdate)
                    completion(.success(conditionsDescription: viewModel.conditionsDescription.string))
                }
            case .failure:
                completion(.init(code: .failure, userActivity: nil))
            }
        }
    }

    func cacheWeatherUpdate(_ weatherUpdate: WeatherUpdate, completion: @escaping () -> Void) {
        guard let cache = WeatherUpdateCache(fileName: WeatherUpdateCache.latestWeatherUpdateFileName) else {
            completion()
            return
        }

        cache.archiveWeatherUpdate(weatherUpdate) { isSuccess, error in
            defer { completion() }
            if isSuccess { return }

            if let error = error {
                os_log("Failed to archive weather update: %{public}@", type: .error, error.localizedDescription)
            } else {
                os_log("Failed to archive weather update", type: .error)
            }
        }
    }
}
