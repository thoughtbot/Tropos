import CoreLocation
import ReactiveObjCBridge
import ReactiveSwift
import Result

extension LocationController {
    public func requestAlwaysAuthorization() -> SignalProducer<Bool, CLError> {
        return SignalProducer(.defer(__requestAlwaysAuthorization))
            .map { $0!.boolValue }
            .mapError { $0.error as! CLError }
    }

    public func updateCurrentLocation() -> SignalProducer<CLLocation, CLError> {
        return SignalProducer(__updateCurrentLocation())
            .map { $0! }
            .mapError { $0.error as! CLError }
    }
}
