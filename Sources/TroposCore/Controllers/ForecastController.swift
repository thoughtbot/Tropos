import CoreLocation
import ReactiveSwift
import Result

private var locationNotFound: Error {
    return NSError(domain: TRErrorDomain, code: TRError.conditionsResponseLocationNotFound.rawValue)
}

private var responseFailed: Error {
    return NSError(domain: TRErrorDomain, code: TRError.conditionsResponseFailed.rawValue)
}

private var unexpectedFormat: Error {
    return NSError(domain: TRErrorDomain, code: TRError.conditionsResponseUnexpectedFormat.rawValue)
}

@objc(TRForecastController)
public final class ForecastController: NSObject {
    private let baseURL: URL
    private let urlSession: URLSession

    @objc(initWithAPIKey:)
    public init(apiKey: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.forecast.io"
        components.path = "/forecast/\(apiKey)"
        baseURL = components.url!

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept": "application/json"]
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        urlSession = URLSession(configuration: configuration)
    }

    public func fetchWeatherUpdate(for placemark: CLPlacemark) -> SignalProducer<WeatherUpdate, AnyError> {
        guard let location = placemark.location else { return SignalProducer(error: AnyError(locationNotFound)) }

        let today = conditionsRequest(for: location.coordinate, date: nil)
        let yesterday = conditionsRequest(for: location.coordinate, date: .yesterday)

        return fetch(today).zip(with: fetch(yesterday)).map {
            WeatherUpdate(placemark: placemark, currentConditionsJSON: $0, yesterdaysConditionsJSON: $1)
        }
    }

    private func fetch(_ conditionsRequest: URLRequest) -> SignalProducer<[String: Any], AnyError> {
        return urlSession.reactive.data(with: conditionsRequest).attemptMap {
            let (data, response) = $0
            guard 200 ..< 300 ~= (response as! HTTPURLResponse).statusCode else { throw responseFailed }

            let json = try JSONSerialization.jsonObject(with: data)

            if let object = json as? [String: Any] {
                return object
            } else {
                throw unexpectedFormat
            }
        }
    }

    private func conditionsRequest(for location: CLLocationCoordinate2D, date: Date?) -> URLRequest {
        var location = String(format: "%f,%f", location.latitude, location.longitude)

        if let date = date {
            location += String(format: ",%.0f", date.timeIntervalSince1970)
        }

        var components = URLComponents(
            url: baseURL.appendingPathComponent(location),
            resolvingAgainstBaseURL: true
        )!

        components.queryItems = [
            URLQueryItem(name: "exclude", value: "minutely,hourly,alerts,flags"),
        ]

        return URLRequest(url: components.url!)
    }
}
