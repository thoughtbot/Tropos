import CoreLocation
import TroposCore

class TestLocationController: LocationController {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override func authorizationStatusEqualTo(_ status: CLAuthorizationStatus) -> Bool {
        return authorizationStatus == status
    }
}
