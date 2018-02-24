import CoreLocation
import Foundation

protocol Geocoder: class {
    func reverseGeocodeLocation(
        _ location: CLLocation,
        completionHandler: @escaping CoreLocation.CLGeocodeCompletionHandler)

    func cancelGeocode()
}

extension CLGeocoder: Geocoder {}
