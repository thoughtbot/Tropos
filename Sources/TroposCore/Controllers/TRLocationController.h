@import CoreLocation;
@import Foundation;
@import ReactiveObjC;

@interface TRLocationController : NSObject

- (RACSignal<NSNumber *> *)requestAlwaysAuthorization;
- (RACSignal<CLLocation *> *)updateCurrentLocation;
- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status;

@end
