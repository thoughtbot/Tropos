@interface TRLocationController : NSObject

- (RACSignal *)requestWhenInUseAuthorization;
- (RACSignal *)updateCurrentLocation;

@end
