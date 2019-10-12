import ReactiveObjCBridge
import ReactiveSwift

extension ForecastController {
    @objc(fetchWeatherUpdateForPlacemark:)
    // swiftlint:disable:next identifier_name
    public func __fetchWeatherUpdate(for placemark: CLPlacemark) -> RACSignal<WeatherUpdate> {
        return fetchWeatherUpdate(for: placemark).bridged
    }
}
