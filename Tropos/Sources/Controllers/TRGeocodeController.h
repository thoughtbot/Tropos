@class CLLocation;

@interface TRGeocodeController : NSObject

- (RACSignal *)reverseGeocodeLocation:(CLLocation *)location;

@end
