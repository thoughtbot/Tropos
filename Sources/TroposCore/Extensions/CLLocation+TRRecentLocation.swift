import CoreLocation

extension CLLocation {
    @objc(tr_isStale) var isStale: Bool {
        return Date().timeIntervalSince(timestamp) > 5
    }
}
