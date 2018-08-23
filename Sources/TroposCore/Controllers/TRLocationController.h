@import CoreLocation;
@import Foundation;
@import ReactiveObjC;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LocationController)
@interface TRLocationController : NSObject

- (RACSignal<NSNumber *> *)requestAlwaysAuthorization NS_REFINED_FOR_SWIFT;
- (RACSignal<CLLocation *> *)updateCurrentLocation NS_REFINED_FOR_SWIFT;
- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status;

@end

NS_ASSUME_NONNULL_END
