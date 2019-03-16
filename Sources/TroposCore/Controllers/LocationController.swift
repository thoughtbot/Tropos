import CoreLocation
import Foundation
import ReactiveObjCBridge
import ReactiveSwift
import Result

@objc(TRLocationController)
open class LocationController: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private let locationUpdates = Signal<CLLocation, NoError>.pipe()
    private let locationUpdateError = Signal<CLError, NoError>.pipe()

    private let statusChanged = Signal<CLAuthorizationStatus, NoError>.pipe()
    private let authorizationStatus: Property<CLAuthorizationStatus>

    @objc public init(locationManager: CLLocationManager) {
        self.authorizationStatus = Property(
            initial: CLLocationManager.authorizationStatus(),
            then: statusChanged.output
        )
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    @objc public convenience override init() {
        if #available(iOSApplicationExtension 10.0, *) {
            dispatchPrecondition(condition: .onQueue(.main))
        }

        self.init(locationManager: CLLocationManager())
    }

    @objc open func authorizationStatusEqualTo(_ status: CLAuthorizationStatus) -> Bool {
        return CLLocationManager.authorizationStatus() == status
    }

    public func requestLocation() -> SignalProducer<CLLocation, CLError> {
        return SignalProducer { [locationManager, locationUpdates, locationUpdateError] observer, lifetime in
            lifetime += locationUpdates.output
                .take(first: 1)
                .promoteError()
                .observe(observer)

            lifetime += locationUpdateError.output.observeValues { error in
                observer.send(error: error)
            }

            lifetime.observeEnded {
                locationManager.stopUpdatingLocation()
            }

            locationManager.startUpdatingLocation()
        }
    }

    public func requestAuthorization() -> SignalProducer<Bool, NoError> {
        return SignalProducer { [authorizationStatus, locationManager] observer, lifetime in
            let isAuthorized = authorizationStatus.producer.filterMap { status -> Bool? in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                case .restricted, .denied:
                    return false
                case .notDetermined:
                    locationManager.requestAlwaysAuthorization()
                    return nil
                }
            }.take(first: 1)

            lifetime += isAuthorized.start(observer)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        statusChanged.input.send(value: status)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdates.input.send(value: locations.last!)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateError.input.send(value: error as! CLError)
    }
}

extension LocationController {
    @objc public func updateCurrentLocation() -> RACSignal<CLLocation> {
        return requestLocation().bridged
    }

    @objc public func requestAlwaysAuthorization() -> RACSignal<NSNumber> {
        return requestAuthorization().map(NSNumber.init).bridged
    }
}
