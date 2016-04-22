@interface TRLocationController : NSObject

- (RACSignal *)requestAlwaysAuthorization;
- (RACSignal *)updateCurrentLocation;
- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status;

@end
