import ReactiveObjCBridge
import ReactiveSwift
import Result

extension ForecastController {
    public func fetchWeatherUpdate(for placemark: CLPlacemark) -> SignalProducer<WeatherUpdate, AnyError> {
        return SignalProducer(__fetchWeatherUpdate(for: placemark)).map { $0 as! WeatherUpdate }
    }
}
