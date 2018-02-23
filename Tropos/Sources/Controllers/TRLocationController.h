@import CoreLocation;
@import Foundation;
#import <ReactiveObjC/ReactiveObjC.h>

@interface TRLocationController : NSObject

- (RACSignal *)requestAlwaysAuthorization;
- (RACSignal *)updateCurrentLocation;
- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status;

@end
