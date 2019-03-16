import CoreLocation
import Foundation
import MapKit
import Result
@testable import TroposCore

final class TestGeocoder: Geocoder {
    private enum State {
        case ready
        case geocoding
        case cancelled
    }

    private var geocodeState = State.ready
    private let result: Result<String, CLError>

    init(name: String) {
        self.result = .success(name)
    }

    init(error code: CLError.Code) {
        let error = NSError(domain: CLError.errorDomain, code: code.rawValue) as! CLError
        result = .failure(error)
    }

    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        precondition(geocodeState == .ready)
        geocodeState = .geocoding

        DispatchQueue.main.async {
            defer { self.geocodeState = .ready }

            guard self.geocodeState != .cancelled else {
                let error = NSError(domain: CLError.errorDomain, code: CLError.geocodeCanceled.rawValue) as! CLError
                completionHandler(nil, error)
                return
            }

            switch self.result {
            case let .success(name):
                let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: ["Name": name])
                completionHandler([placemark], nil)
            case let .failure(error):
                completionHandler(nil, error)
            }
        }
    }

    func cancelGeocode() {
        if geocodeState == .geocoding {
            geocodeState = .cancelled
        }
    }
}
