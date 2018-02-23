import CoreLocation
import Foundation
import MapKit

final class TestGeocoder: NSObject, Geocoder {
    private var name: String?
    private var error: Error?

    init(name: String) {
        self.name = name
    }

    init(error: Error) {
        self.error = error
    }

    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        DispatchQueue.main.async {
            switch (self.name, self.error) {
            case let (name?, _):
                let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: ["Name": name])
                completionHandler([placemark], nil)
            case let (_, error?):
                completionHandler(nil, error)
            default:
                fatalError("unreachable")
            }
        }
    }
}
