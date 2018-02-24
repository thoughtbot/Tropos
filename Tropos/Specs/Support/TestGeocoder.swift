import CoreLocation
import Foundation
import MapKit
import Result

final class TestGeocoder: NSObject, Geocoder {
    private let result: Result<String, AnyError>

    init(name: String) {
        result = .success(name)
    }

    init(error: Error) {
        result = .failure(AnyError(error))
    }

    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        DispatchQueue.main.async {
            switch self.result {
            case let .success(country):
                let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: ["Name": country])
                completionHandler([placemark], nil)
            case let .failure(error):
                completionHandler(nil, error.error)
            }
        }
    }
}
